function Evaluator(applet) {
  this.applet = applet;
  this.currentLine = 0;
  this.errors = "";
}

Evaluator.prototype.setEnvironmentVariables = function(variableList) {
  for(var i in variableList) {
    this.applet.setEnvironmentValue(variableList[i], document.getElementById(variableList[i]).value);
  }
}

Evaluator.prototype.getEnvironmentVariables = function(variableList) {
  for(var i in variableList) {
    document.getElementById(variableList[i]).value = this.applet.getEnvironmentValue(variableList[i]);
  }
}

Evaluator.prototype.stepProgram = function() {
  beforeEvaluate(this);

  updateView(this);
  afterEvaluate(this);
}

Evaluator.prototype.runProgram = function() {
  beforeEvaluate(this);

  this.applet.reset();

  var program = this.getProgramContents();
  var lines = program.split("\n");
  for(var lineNumber in lines) {
    this.applet.evaluate(program, lineNumber);
    updateView(this);
  }

  afterEvaluate(this);
}

Evaluator.prototype.getProgramContents = function() {
  editAreaLoader.setSelectionRange("editor", 0, 50000);
  return editAreaLoader.getSelectedText("editor");
}

Evaluator.prototype.getErrors = function() {
  return this.applet.getErrors();
}