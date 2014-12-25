module Bumper
  class CommandRepository
    attr_reader :options

    def initialize(project, options)
      @project = project
      @options = options
      @cmds = []
      init_cmds
    end

    def add(cmd, type = :system)
      @cmds << Command.new(cmd, type)
    end

    def run!
      @cmds.each do |command|
        command.run { |type| prefix(type) }
        command.print { |type| prefix(type) }
      end

      puts "Success bump current gem in #{ @project }"
    end

    def debug
      @cmds.map do |cmd|
        cmd.print { |type| prefix(type) }
      end.join("\n")
    end

    private

    def init_cmds
      add('rm -rf pkg')
      add('bundle exec rake build')
    end

    def prefix(type)
      if type == :rvm && options[:gemset]
        "rvm #{ options[:gemset] } exec "
      end
    end
  end

  class Command
    attr_reader :command, :type

    def initialize(command, type)
      @command = command
      @type = type
    end

    def run(&block)
      system("#{ block.call(type) }#{ command }")
    end

    def print(&block)
      "#{ block.call(type) }#{ command }"
    end
  end
end