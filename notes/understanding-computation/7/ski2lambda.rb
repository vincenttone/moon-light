require File.dirname(__FILE__) + '/ski.rb'
require File.dirname(__FILE__) + '/../6/lambda_calculus.rb'

class SKISymbol
  def as_a_function_of(name)
    if self.name == name
      I
    else
      SKICall.new(K, self)
    end
  end
end

class SKICombinator
  def as_a_function_of(name)
    SKICall.new(K, self)
  end
end

class SKICall
  def as_a_function_of(name)
    left_function = left.as_a_function_of(name)
    right_function = right.as_a_function_of(name)
    SKICall.new(SKICall.new(S, left_function), right_function)
  end
end

class LCVariable
  def to_ski
    SKISymbol.new(name)
  end
end
  
class LCCall
  def to_ski
    SKICall.new(left.to_ski, right.to_ski)
  end
end
  
class LCFunction
  def to_ski
    body.to_ski.as_a_function_of(parameter)
  end
end
