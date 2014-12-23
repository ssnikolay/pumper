require 'ostruct'
describe Bumper::Bump do
  let(:options) { Hash.new }
  let(:default_options) { { project: 'simple_project' } }

  let(:bumper) { described_class.new(options.merge(default_options)) }
  let(:specification) do
    OpenStruct.new(
      name: 'simple_gem',
      version: '1.0',
      gem_file_name: 'simple_gem-1.0.gem'
    )
  end
  before do
    allow_any_instance_of(Bumper::Bump).to receive(:specification).and_return(specification)
    allow_any_instance_of(Bumper::ProjectGemfile).to receive(:bump_version!)
    allow_any_instance_of(Bumper::CommandRepository).to receive(:run!) { |cmds| cmds.debug }
  end

  describe '.perform' do
    subject { bumper.perform }

    context 'when simple options' do
      it 'should print base commands' do
        should eq(
          <<-output.strip_heredoc.strip
            rm -rf pkg
            rake build
            gem cleanup simple_gem
            gem install ./simple_gem-1.0.gem
          output
        )
      end
    end

    context 'when simple options' do
      let(:options) { { vendor: true } }

      it 'should print vendor commands' do
        should eq(
          <<-output.strip_heredoc.strip
            rm -rf pkg
            rake build
            gem cleanup simple_gem
            cp pkg/* ../simple_project/vendor/cache
            cd ../simple_project && bundle install --local
          output
        )
      end
    end
  end
end