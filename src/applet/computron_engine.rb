require 'java'
require 'polyglot'
require 'treetop'
require 'grammars/external_treetop_nodes'

class ComputronEngine < Java::org::computron::ComputronEvaluator

  DEFAULT_ENVIRONMENT = {
    :result => 0,
    :current_line => 0,
    :label_line_numbers => {},
    :last_result => nil,
    :alias => {},
    :log => []
  }

  def initialize
    puts "Creating parser"
    Treetop.load File.expand_path(File.dirname(__FILE__) + "/grammars/computron")
    @parser = ComputronParser.new
    reset_environment
    puts "Ready to evaluate"
  end

  def evaluate(program, line_number)
    program_length = 0
    line_number = current_line if -1 == line_number
    line_contents = ""
    program.split("\n", -1).each_with_index do |line, index|
      program_length += 1

      line_contents = line if index == line_number
      
      if line.strip =~ /^:/
        @environment[:label_line_numbers][line.strip] = index
      end
    end

    @errors = ""

    unless line_contents.nil?
      node = @parser.parse(remove_aliases(line_contents.strip))
      eval_node(node, line_number)
    end
    puts "after eval: current_line = #{current_line}, program_length = #{program_length}"
  end

  def remove_aliases(line)
    @environment[:alias].inject(line) {|string, mapping| string.gsub(mapping.first, mapping.last)}
  end

  def current_line
    @environment[:current_line]
  end
  alias_method :getCurrentLine, :current_line

  def current_line=(line_number)
    @environment[:current_line] = line_number
  end

  def setEnvironmentValue(name, value)
    @environment[name.intern] = value
  end

  def getEnvironmentValue(name)
    @environment[name.intern] || 0
  end

  def getErrors
    if @errors.nil? || "" == @errors.strip
      "No Errors"
    else
      @errors
    end
  end

  def reset
    reset_environment
  end

private
  def eval_node(node, line_number)
    if node.nil?
      puts "setting error: Error on line #{line_number+1}:\n#{@parser.failure_reason}"
      @errors = "Error on line #{line_number+1}:\n#{@parser.failure_reason}"
    else
      puts "no error for node: #{node}"
      node.eval(@environment)
    end
  end

  def reset_environment
    @environment = Hash.new.merge(DEFAULT_ENVIRONMENT)
    @errors = ""
  end
end
