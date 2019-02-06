class Node2
  # AF: A [Node2] represents a 2-Node in a 23-Tree with [left,val,right] in
  #     ascending order, and with strict inequality betweeen node values.
  # RI: The depth from the node to all leafs is the same.
  def initialize(val,left=nil,right=nil)
    @val, @left, @right =val, left, right
  end

  def node3?
    false
  end

  def to_a
    if empty?
      []
    else
      [ @left.to_a, @val, @right.to_a ].flatten
    end
  end

  # [tree.to_list] returns a least in ascending order of all [keys] in [tree]
  def to_list
    if empty?
      return []
    end
    if @left!=nil
      [ @left.to_list, [@val[0]], @right.to_list ].flatten
    else
      [ @val[0] ]
    end
  end

  def to_s
    (@left.to_s+" "+@val.to_s+" "+@right.to_s).strip
  end

  # This instance method should return true if the tree is empty, false otherwise
  # requires: the instance satisfies the invariant
  def empty?
    @val==nil
  end

  # [Node2.empty] returns an instance of an empty [Node2]
  def self.empty
    Node2.new(nil)
  end

  # This instance method should return true if the tree is a kickup, false otherwise
  # requires: the instance satisfies the invariant
  def kick?
    false
  end

  # [tree.node2_depth] should return the depth of the 2-node [tree], or -1
  # if the depth invariant is not satisfied.
  # require: [tree] should be a nonempty 2-node
  def depth
    if empty?
      0
    else
      if @left==nil || @right==nil
        if (@left==nil&&@right==nil) then 1
        else -1
        end
      else
        left, right = @left.depth, @right.depth
        if left==-1||right==-1||left!=right then -1
        else 1+left
        end
      end
    end
  end

  # [tree.replace(tree_,value)] returns a new [tree'] with one of [tree]'s
  # substrees replaced by [tree_]. If [value==-1], the left subtree is replaced,
  # otherwise the right subtree is replaced
  def replace(tree_,value)
    if value==-1
      Node2.new(@val,tree_,@right)
    else
      Node2.new(@val,@left,tree_)
    end
  end

  # [tree.help_two(tree_,k,v,i)] returns a [tree'] with the binding (k,v) added
  # to the subtree [tree_]
  # require: if [tree_] is the left subtree of [tree], then i=-1, otherwise i=1
  def help_two(tree,key,value,compare)
    if tree == nil
      tree_ = Kickup.new([key,value])
    else
      tree_ = tree.insert_help(key,value)
    end
    if tree_.kick?
      if compare==-1
        Node3.new(tree_.val,@val,tree_.left,tree_.right,@right)
      else
        Node3.new(@val,tree_.val,@left,tree_.left,tree_.right)
      end
    else
      replace(tree_,compare)
    end
  end

  # [tree.insert_help(k,v)] returns a new [tree'] or [kickup] with [v] bound to
  # [k]. If [k] is in [tree], [tree'] replaces [k]'s old binding with [v]
  def insert_help(key,value)
    val=[key,value]
    if empty?
      Kickup.new(val)
    elsif @val[0] == key
      Node2.new(val,@left,@right)
    elsif @val[0] > key
      help_two(@left,key,value,-1)
    else
      help_two(@right,key,value,0)
    end
  end

  # [tree.insert(key,value)] returns a new [tree'] with [value] bound to [key].
  # If [key] is in [tree], [tree'] replaces [key]'s old binding with [value]
  def insert(key,value)
    tree = insert_help(key,value)
    if tree.kick?
      tree.to_tree
    else
      tree
    end
  end

  # [tree.find(key)] returns [val] when [tree] maps [key] to [val], or
  # [nil] if [key] is not in [tree]
  def find(key)
    if empty?
      nil
    else
      if @val[0] == key
        @val
      elsif @val[0] < key && @right!=nil
        @right.find(key)
      elsif @left!=nil
        @left.find(key)
      else
        nil
      end
    end
  end

  # This method should return true if [key] is in the 2-Node, false otherwise
  def mem(key)
    nil == find(key)
  end

end
