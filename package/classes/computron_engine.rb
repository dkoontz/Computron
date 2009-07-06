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
  end

  def setEnvironmentValue(name, value)
    puts "setting #{name} to #{value}"
    @environment[name] = value
    puts @environment.inspect
  end

  def getEnvironmentValue(name)
    puts "getting #{name} which has a value of #{@environment[name]}"
    @environment[name]
  end

  def reset
    reset_environment
  end

private
  def reset_environment
    puts "resetting environement"
    @environment = Hash.new.merge(DEFAULT_ENVIRONMENT)
    puts @environment.inspect
  end
end
