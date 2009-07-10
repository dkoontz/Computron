#  Copyright (c) 2009, David Koontz
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without modification,
#  are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list
#    of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this
#    list of conditions and the following disclaimer in the documentation and/or other
#    materials provided with the distribution.
#  * Neither the name of David Koontz or Computron may be used to endorse or promote
#    products derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
#  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
#  AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
#  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
#  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
#  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
    @ready = false
    puts "Creating parser"
    Treetop.load File.expand_path(File.dirname(__FILE__) + "/grammars/computron")
    @parser = ComputronParser.new
    @program = ""
    @program_lines = []
    reset
    puts "Ready to evaluate"
    @ready = true
  end

  def evaluate(line_number)
    line_number = current_line if -1 == line_number
    @errors = ""

    unless @program_lines[line_number].nil?
      node = @parser.parse(remove_aliases(@program_lines[line_number].strip))
      eval_node(node, line_number)
    end
  end

  def current_line
    @environment[:current_line]
  end
  alias_method :getCurrentLine, :current_line

  def current_line=(line_number)
    @environment[:current_line] = line_number
  end
  alias_method :setCurrentLine, :current_line=

  def program
    @program
  end
  alias_method :getProgram, :program

  def program=(program)
    @program = program
    @program_lines = @program.split("\n", -1)

    @program_lines.each_with_index do |line, index|
      if line.strip =~ /^:/
        @environment[:label_line_numbers][line.strip] = index
      end
    end
  end
  alias_method :setProgram, :program=

  def program_lines
    @program_lines
  end

  def getProgramLines
    @program_lines.to_java(:string)
  end

  def program_line_count
    @program_lines.length
  end
  alias_method :getProgramLineCount, :program_line_count

  def setEnvironmentValue(name, value)
    @environment[name.intern] = value
  end

  def getEnvironmentValue(name)
    @environment[name.intern] || 0
  end

  def errors
    if @errors.nil? || "" == @errors.strip
      "No Errors"
    else
      @errors
    end
  end
  alias_method :getErrors, :errors

  def reset
    @environment = Hash.new.merge(DEFAULT_ENVIRONMENT)
    @errors = ""
  end

  def ready
    @ready
  end

private
  def eval_node(node, line_number)
    if node.nil?
      puts "setting error: Error on line #{line_number+1}:\n#{@parser.failure_reason}"
      @errors = "Error on line #{line_number+1}:\n#{@parser.failure_reason}"
    else
      node.eval(@environment)
    end
  end

  def remove_aliases(line)
    @environment[:alias].inject(line) {|string, mapping| string.gsub(mapping.first, mapping.last)}
  end
end
