# -*- coding: utf-8 -*-
class SKISymbol < Struct.new(:name)
  def to_s
    name.to_s
  end
  def inspect
    to_s
  end
end


class SKICall < Struct.new(:left, :right)
  def to_s
    "#{left}[#{right}]"
  end
  def inspect
    to_s
  end
end

class SKICombinator < SKISymbol
end

S, K, I = [:S, :K, :I].map { |name|
  SKICombinator.new(name)
}
def S.call(a, b, c)
  SKICall.new(SKICall.new(a, c), SKICall.new(b, c))
end

def K.call(a, b)
  a
end

def I.call(a)
  a
end

class SKISymbol
  def combinator
    self
  end

  def arguments
    []
  end
end

class SKICall
  def combinator
    left.combinator
  end

  def arguments
    left.arguments + [right]
  end
end

class SKISymbol
  def callable?(*arguments)
    false
  end
end

def S.callable?(*arguments)
  arguments.length == 3
end
  
def K.callable?(*arguments)
  arguments.length == 2
end
  
def I.callable?(*arguments)
  arguments.length == 1
end

class SKISymbol
  def reducible?
    false
  end
end

class SKICall
  def reducible?
    left.reducible? || right.reducible? || combinator.callable?(*arguments)
  end

  def reduce
    if left.reducible?
      SKICall.new(left.reduce, right)
    elsif right.reducible?
      SKICall.new(left, right.reduce)
    else
      combinator.call(*arguments)
    end
  end
end
