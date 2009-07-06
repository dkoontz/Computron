class ShapeNode < Treetop::Runtime::SyntaxNode
  def eval(environment)
    environment[name]
  end

  def name(environment = {})
    text_value.intern
  end
end