require 'ripl'

module Ripl
  module Commands
    VERSION = '0.1.0'

    module Core
      def self.jumps
        @jumps ||= [Ripl.shell.loop_eval("self")]
      end

      def list
        Ripl::Commands.instance_methods
      end

      def config(name, val)
        Ripl.shell.respond_to?("#{name}=") ? Ripl.shell.send("#{name}=", val) :
          Ripl.config[name] = val
      end

      def jump(obj)
        obj = Core.jumps[obj] || obj if obj.is_a?(Fixnum)
        if !Core.jumps.include?(obj)
          Core.jumps << obj
          Ripl.shell.add_commands(obj)
        end
        Ripl.shell.binding = obj.instance_eval{ binding }
        obj
      end

      def jumps
        Core.jumps
      end
    end
  end
end

Ripl::Commands.send :include, Ripl::Commands::Core
