require 'ostruct'
describe Pumper::Pump do
  let(:options) { Hash.new }
  let(:default_options) { { project: 'simple_project' } }

  let(:pumper) { described_class.new(options.merge(default_options)) }
  let(:specification) do
    OpenStruct.new(
      name: 'simple_gem',
      version: '1.0',
      gem_file_name: 'simple_gem-1.0.gem'
    )
  end
  before do
    allow_any_instance_of(Pumper::Pump).to receive(:specification).and_return(specification)
    allow_any_instance_of(Pumper::UpdatingProject).to receive(:bump_version!)
    allow_any_instance_of(Command::Repository).to receive(:execute) { |cmds| cmds.debug }
  end

  describe '.perform' do
    subject { pumper.perform }

    context 'when simple options' do
      it 'should print base commands' do
        should eq(
          <<-output.strip_heredoc.strip
            rm -rf pkg
            bundle exec rake build
            gem uninstall simple_gem --all -x
            gem install ./pkg/simple_gem-1.0.gem
          output
        )
      end
    end

    context 'when vendor options' do
      let(:options) { { vendor: true } }

      it 'should print vendor commands' do
        should eq(
          <<-OUTPUT.strip_heredoc.strip
            rm -rf pkg
            bundle exec rake build
            gem uninstall simple_gem --all -x
            cp pkg/* #{ Dir.pwd }/../simple_project/vendor/cache
            cd #{ Dir.pwd }/../simple_project
            bundle install --local
          OUTPUT
        )
      end
    end

    context 'when gemset options' do
      let(:options) { { gemset: '1.9.3@simple_project' } }

      it 'should print gemset commands' do
        should eq(
          <<-output.strip_heredoc.strip
            rm -rf pkg
            bundle exec rake build
            rvm 1.9.3@simple_project exec gem uninstall simple_gem --all -x
            rvm 1.9.3@simple_project exec gem install ./pkg/simple_gem-1.0.gem
          output
        )
      end
    end
  end
end