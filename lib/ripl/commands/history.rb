require 'tempfile'

module Ripl::Commands::History
  def history(*args)
    Ripl::Commands::History.history(*args)
  end

  def editor(*args)
    Ripl::Commands::History.edit(*args)
  end

  class << self
    def history(last=10)
      slice_history(last).each_with_index do |e,i|
        puts "#{last - i}: #{e}"
      end
    end

    def edit(last=nil)
      body = if last.nil? && @last_edit
        @last_edit
      elsif last.is_a?(Fixnum)
        start = Array(Ripl.shell.history)[-2].start_with?('history') ? 2 : 1
        slice_history(last, start).join("\n")
      else
        ''
      end
      file = Tempfile.new(['ripl-editor', '.rb']).path
      File.open(file, 'w') {|f| f.puts(body) }
      system(editor, file)
      Ripl.shell.loop_eval(@last_edit = File.read(file))
    end

    def editor
      ENV['EDITOR'] ? ENV['EDITOR'].split.first : 'vim'
    end

    def slice_history(last, start=1)
      Array(Ripl.shell.history).reverse.slice(start, last).reverse
    end
  end
end

Ripl::Commands.include Ripl::Commands::History
