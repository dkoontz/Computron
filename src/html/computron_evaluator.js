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

function Evaluator(applet) {
  this.applet = applet;
  this.intervalId = null;
  this.running = false;

  callback = function(applet, object) {
    return function() {
      if(applet.ready()) {
        object.markReady();
      }
    }
  }
  this.checkIfReadyIntervalId = setInterval(callback(applet, this), 10);
}

Evaluator.prototype = {
  setEnvironmentVariables : function(variableList) {
    for(var i in variableList) {
      this.applet.setEnvironmentValue(variableList[i], document.getElementById(variableList[i]).value);
    }
  },

  getEnvironmentVariables : function(variableList) {
    for(var i in variableList) {
      document.getElementById(variableList[i]).value = this.applet.getEnvironmentValue(variableList[i]);
    }
  },

  stepProgram : function() {
    if(0 == this.getLineNumber()) {
      beforeEvaluate(this);
    }

    this.applet.evaluate(-1);
    updateView(this);

    if(this.getLineNumber() == this.getLineCount()) {
      this.stop();
    }
  },

  runProgram : function() {
    this.applet.reset();
    callback = function(object) {
      return function() {object.stepProgram(); }
    }

    this.intervalId = setInterval(callback(this), 10);
  },

  stop : function() {
    afterEvaluate(this);
    
    if(null != this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  },

  reset : function() {
    this.applet.reset();
  },

  setProgram : function(program) {
    this.applet.setProgram(program);
  },

  getErrors : function() {
    return this.applet.getErrors();
  },

  getLineNumber : function() {
    return this.applet.getCurrentLine();
  },

  getLineCount : function() {
    return this.applet.getProgramLineCount();
  },

  getCurrentLineStart : function() {
    // Selection ranges for edit area are by character, not line number

    var lines = this.applet.getProgramLines();
    var highlightStart = 0;
    for(var i = 0; i < this.getLineNumber(); i++) {
      highlightStart += lines[i].length + 1;
    }
    return highlightStart;
  },

  getCurrentLineEnd : function() {
    return this.getCurrentLineStart() + this.applet.getProgramLines()[this.getLineNumber()].length;
  },

  markReady : function() {
    clearInterval(this.checkIfReadyIntervalId);
    evaluatorReady();
  }
}