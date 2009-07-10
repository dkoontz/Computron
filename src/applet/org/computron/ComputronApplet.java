/*
    Copyright (c) 2009, David Koontz
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification,
    are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list
      of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this
      list of conditions and the following disclaimer in the documentation and/or other
      materials provided with the distribution.
    * Neither the name of David Koontz or Computron may be used to endorse or promote
      products derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
    OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
    AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
    CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
    IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
    OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package org.computron;

import java.applet.Applet;
import java.util.ArrayList;
import org.jruby.Ruby;
import org.jruby.javasupport.JavaEmbedUtils;
import org.jruby.runtime.builtin.IRubyObject;

public class ComputronApplet extends Applet {

  Ruby runtime;
  ComputronEvaluator computron;

  @Override
  public void init() {
    runtime = JavaEmbedUtils.initialize(new ArrayList());
    IRubyObject engineClass = JavaEmbedUtils.newRuntimeAdapter().eval(runtime, "require 'computron_engine'; ComputronEngine");
    computron = (ComputronEvaluator)JavaEmbedUtils.invokeMethod(runtime, engineClass, "new", null, ComputronEvaluator.class);
  }

  public void evaluate(int lineNumber) {
    computron.evaluate(lineNumber);
  }

  public void setEnvironmentValue(String name, int value) {
    computron.setEnvironmentValue(name, value);
  }

  public int getEnvironmentValue(String name) {
    return computron.getEnvironmentValue(name);
  }

  public String getErrors() {
    return computron.getErrors();
  }

  public void reset() {
    computron.reset();
  }

  public int getCurrentLine() {
    return computron.getCurrentLine();
  }

  public void setCurrentLine(int line) {
    computron.setCurrentLine(line);
  }

  public String getProgram() {
    return computron.getProgram();
  }

  public void setProgram(String program) {
    computron.setProgram(program);
  }

  public String[] getProgramLines() {
    return computron.getProgramLines();
  }

  public int getProgramLineCount() {
    return computron.getProgramLineCount();
  }
}