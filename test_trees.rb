require_relative 'node2'
require_relative 'node3'
require_relative 'kickup'
require 'test/unit'

class TestTrees < Test::Unit::TestCase
  def test_simple
    empty = Node2.new(nil)
    zero = empty.insert(0,0)
    minus = zero.insert(-1,-1)
    plus = zero.insert(1,1)
    dep2pos = minus.insert(1,1)
    dep2neg = plus.insert(-1,-1)
    repl = dep2pos.insert(0,10)
    repl2 = repl.insert(-1,-10)
    big = repl.insert(-10,1).insert(-5,0).insert(5,0).insert(10,0).insert(1000,1000)
    ar = [-1,-1,0,0,1,1]
    lst = [-1,0,1]
    ar_rep = [-1,-1,0,10,1,1]
    ar_rep2 =  [-1,-10,0,10,1,1]

    big_l = [-10,-5,-1,0,1,5,10,1000]

    assert_equal(0, Node2.new(nil).depth)
    assert_equal(1, zero.depth)
    assert_equal(1, minus.depth)
    assert_equal([-1,-1,0,0], minus.to_a)
    assert_equal(1, plus.depth)
    assert_equal([0,0,1,1], plus.to_a)
    assert_equal(2, dep2pos.depth)
    assert_equal(ar, dep2pos.to_a)
    assert_equal(lst, dep2pos.to_list)
    assert_equal(2, dep2neg.depth)
    assert_equal(ar, dep2neg.to_a)
    assert_equal(lst, dep2neg.to_list)

    assert_equal(ar_rep, repl.to_a)
    assert_equal(ar_rep2,repl2.to_a)

    assert_equal(big_l,big.to_list)

    # >>>>>>>>>>>>>>>>>>> find >>>>>>>>>>>>>>>>>>>>>>
    assert_equal(1000,big.find(1000))
    assert_equal(0,big.find(-5))
    assert_equal(10,big.find(0))
    assert_equal(1,big.find(1))
    assert_equal(1,big.find(-10))
    assert_equal(10,big.insert(-10,10).find(-10))
  end
end
