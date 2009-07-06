package org.computron;

public abstract class ComputronEvaluator {
  public abstract void evaluate(String program);
  public abstract void setEnvironmentValue(String name, int value);
  public abstract int getEnvironmentValue(String name);
  public abstract void reset();
}