class Kickup
  # AF: A [Kickup] represents 2-Node in the upward phase of insertion into a
  #     23-Tree with [left,val,right] in ascending order, and with strict
  #     inequality betweeen node values.
  # RI: The depth from the node to all leafs is the same.
  def initialize(val,left=nil,right=nil)
    @val, @left, @right = val, left, right
  end

  attr_reader :val, :left, :right

  # This instance method should return true if the tree is a kickup, false otherwise
  # requires: the instance satisfies the invariant
  def kick?
    true
  end

  def to_s
    (@left.to_s+" #{@val} "+@right.to_s).strip
  end

  # [kickup.to_tree] returns a [Node2] with the same values as [kickup]
  def to_tree
    Node2.new(@val,@left,@right)
  end
end
