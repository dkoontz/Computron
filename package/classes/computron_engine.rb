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
    puts "Setting default environment"
    reset_environment
  end

  def evaluate(program)
    puts "evaluating program: #{program}"

    program_length = 0
    program.split("\n").each_with_index do |line, index|
      program_length += 1
      
      if line.strip =~ /^:/
        @environment[:label_line_numbers][line.strip] = index
      end
    end

    @errors = ""
    
    until current_line == program_length
      node = @parser.parse(remove_aliases(program.split("\n")[current_line].strip))
      eval_node(node, current_line)
      self.current_line += 1
    end
  end

  def remove_aliases(line)
    @environment[:alias].inject(line) {|string, mapping| string.gsub(mapping.first, mapping.last)}
  end

  def current_line
    @environment[:current_line]
  end

  def current_line=(line_number)
    @environment[:current_line] = line_number
  end

  def setEnvironmentValue(name, value)
    puts "setting #{name} to #{value}"
    @environment[name.intern] = value
    puts @environment.inspect
  end

  def getEnvironmentValue(name)
    puts @environment.inspect
    puts "getting #{name} which has a value of #{@environment[name.intern]}"
    @environment[name.intern]
  end

  def reset
    reset_environment
  end

private
  def eval_node(node, line_number)
    if node.nil?
      @errors =  "Error on line #{line_number+1}:\n#{@parser.failure_reason}"
    else
      node.eval(@environment)
    end
  end

  def reset_environment
    puts "resetting environement"
    @environment = Hash.new.merge(DEFAULT_ENVIRONMENT)
    puts @environment.inspect
  end
end
