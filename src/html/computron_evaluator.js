function Evaluator(applet) {
  this.applet = applet;
  this.programLineCount = 0;
  this.program = null;
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
    if(null == this.program) {
      this.program = this.getProgramContents();
      this.programLineCount = this.getProgramContents().split("\n").length;
    }

    if(0 == this.applet.getCurrentLine()) {
      beforeEvaluate(this);
    }

    this.applet.evaluate(this.program, -1);
    updateView(this);
    
    if(this.applet.getCurrentLine() > this.programLineCount - 1) {
      this.stop();
    }
  },

  runProgram : function() {
    this.applet.reset();

    beforeEvaluate(this);

    var program = this.getProgramContents();
    var lines = program.split("\n");
    this.programLineCount = lines.length;

    while(this.applet.getCurrentLine() <= this.programLineCount - 1) {
      this.applet.evaluate(program, -1);
      updateView(this);
    }

    afterEvaluate(this);
  },

  stop : function() {
    afterEvaluate(this);
    
    this.program = null;
    this.programLineCount = 0;
  },

  getProgramContents : function() {
    editAreaLoader.setSelectionRange("editor", 0, 50000);
    return editAreaLoader.getSelectedText("editor");
  },

  getErrors : function() {
    return this.applet.getErrors();
  },

  getLineNumber : function() {
    return this.applet.getCurrentLine();
  },

  getLineCount : function() {
    return this.programLineCount;
  }
}