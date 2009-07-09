package org.computron;

public abstract class ComputronEvaluator {
  public abstract void evaluate(String program, int lineNumber);
  public abstract void setEnvironmentValue(String name, int value);
  public abstract int getEnvironmentValue(String name);
  public abstract int getCurrentLine();
  public abstract String getErrors();
  public abstract void reset();
}