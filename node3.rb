class Node3
  # AF: A [Node3] represents a 3-Node in a 23-Tree with [left,lval,middle,rval,right]
  #     in ascending order, and with strict inequality betweeen node values.
  # RI: The depth from the node to all leafs is the same. If any subtree is
  #     [nil], the [tree] must be empty
  def initialize(lval,rval,left=nil,middle=nil,right=nil)
    @left, @lval, @middle, @rval, @right = left, lval, middle, rval, right
  end

  def node3?
    true
  end

  def to_a
    [ @left.to_a, @lval, @middle.to_a, @rval, @right.to_a ].flatten
  end

  # [tree.to_list] returns a least in ascending order of all [keys] in [tree]
  def to_list
    if @left!=nil
      [ @left.to_list, [@lval[0]], @middle.to_list, [@rval[0]], @right.to_list ].flatten
    else
      [ @lval[0], @rval[0] ]
    end
  end

  def to_s
    (@left.to_s+" "+@lval.to_s+" "+@middle.to_s+" "+@rval.to_s+" "+@right.to_s).strip
  end

  # This instance method should return true if the tree is a kickup, false otherwise
  # requires: the instance satisfies the invariant
  def kick?
    false
  end

  # [tree.node3_depth] should return the depth of the 3-node [tree], or -1
  # if the depth invariant is not satisfied.
  # require: [tree] should be a nonempty 3-node
  def depth
    if @left==nil || @middle==nil || @right==nil
      if (@left==nil&&@middle==nil&&@right==nil)
        1
      else
        -1
      end
    else
      left, middle, right = @left.depth, @middle.depth, @right.depth
      if left==-1||middle==-1||right==-1||left!=middle||middle!=right
        -1
      else
        1+left
      end
    end
  end

  # [tree.replace(tree_,value)] returns a new [tree'] with one of [tree]'s
  # substrees replaced by [tree_]. If [value==-1], the left subtree is replaced,
  # if [value==0], the middle subtree, otherwise the right subtree is replaced
  def replace(tree_,value)
    if value==-1
      Node3.new(@lval,@rval,tree_,@middle,@right)
    elsif value==0
      Node3.new(@lval,@rval,@left,tree_,@right)
    else
      Node3.new(@lval,@rval,@left,@middle,tree_)
    end
  end

  # [tree.help_three(tree_,k,v,i)] returns a [tree'] with the binding (k,v)
  # added to the subtree [tree_]
  # require: if [tree_] is the left subtree of [tree], then i=-1, if [tree_] is
  # the middle subtree then i=0, otherwise i=1
  def help_three(tree,key,value,compare)
    if tree==nil
      tree_ = Kickup.new([key,value])
    else
      tree_=tree.insert_help(key,value)
    end
    if tree_.kick?
      if compare==-1
        right = Node2.new(@rval,@middle,@right)
        left = tree_.to_tree
        Kickup.new(@lval,left,right)
      elsif compare==0
        left = Node2.new(@lval,@left,tree_.left)
        right = Node2.new(@rval,tree_.right,@right)
        Kickup.new(tree_.val,left,right)
      else
        left = Node2.new(@lval,@left,@middle)
        right = tree_.to_tree
        Kickup.new(@rval,left,right)
      end
    else
      replace(tree_,compare)
    end
  end

  # [tree.insert_help(k,v)] returns a new [tree'] or [kickup] with [v] bound to
  # [k]. If [k] is in [tree], [tree'] replaces [k]'s old binding with [v]
  def insert_help(key,value)
    val=[key,value]
    if @lval[0] == key
      Node3.new(val,@rval,@left,@middle,@right)
    elsif @lval[0] > key
      help_three(@left,key,value,-1)
    else
      if @rval[0] == key
      Node3.new(@lval,val,@left,@middle,@right)
      elsif @rval[0] > key
        help_three(@middle,key,value,0)
      else
        help_three(@right,key,value,1)
      end
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
    if @lval[0] == key
      @lval
    elsif @lval[0] > key && @left!=nil
      @left.find(key)
    else
      if @rval[0] == key
        @rval
      elsif @rval[0] > key && @middle!=nil
        @middle.find(key)
      elsif @right!=nil
        @right.find(key)
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
