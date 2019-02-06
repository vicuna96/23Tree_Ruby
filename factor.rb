class Factor

  # This method modifies [hash] by setting [hash[letter]=init] if letter
  # was not a key, or setting [hash[letter]] to the return of the evaluation of
  # the lambda [other]
  def self.insert_hash_l(hash,letter,init,other)
    if hash[letter]==nil
      hash[letter]=init
    else
      hash[letter]=other.call
    end
    hash
  end

  # This method returns a [hash] of regex words in the field [str] of the hashes
  # in the array produced by the execution of [lamb1], minus the words [s] and [t]
  def self.words_l(lamb1, str)
    hash=Hash.new
    lamb1.call.each do |spell|
      spell[str].scan(/\w+/).each do |word|
        Factor.insert_hash_l(hash,word,1,lambda {hash[word]+1})
      end
    end
    hash['s']=nil
    hash['t']=nil
    hash
  end

  # This method returns an order [array] of [word,number of ocurrances] pairs
  # of the regex words in the field [str] of the hashes in the array produced by
  # [lamb1]
  def self.word_frequency(lamb1,str)
    Factor.words_l(lamb1,str).sort {|a,b| a[1]<=>b[1]}
  end

  # This method returns a [hash] that maps [numbers] to lists of [regex words],
  # describing the number of ocurrances of words in the field [str] of the hashes
  # in the array produced by [lamb1]
  def self.by_frequency(lamb)
    hash = Hash.new
    lamb.call.words.each do |key,value|
      Factor.insert_hash_l(hash,value,[key],lambda {hash[value] << key})
    end
    hash
  end

  # This method should return a hash with the lowercase spell names as keys
  # and the corresponding instance of spell as a value
  def self.hash(lamb,str)
    hash = Hash.new
    lamb.call.data.each do |spell|
      hash[spell[str].downcase]=lamb.call.new(spell)
    end
    hash
  end

  # This method should return a 23-Tree with the lowercase spell names as keys
  # and the corresponding instance of spell as a value
  def self.tree(lamb,str)
    tree = Node2.empty
    lamb.call.data.each do |spell|
      tree = tree.insert(spell[str].downcase,lamb.call.new(spell))
    end
    tree
  end

  # This method returns an array containing the mentions from secret.json
  def self.secret(str)
    path = 'data/secret.json'
    file = File.read(path)
    JSON.parse(file)[str]
  end

  # This method evaluates [lamb] into an array of hashes and returns an [array']
  # containing the field values for [str] of each of those hashes
  def self.arrays(lamb,str)
    lst = []
    lamb.call.each do |el|
      lst << el[str]
    end
    lst
  end

  # This method returns an array with [0] all the elements in [ar1-ar2] and [1]
  # all the elements in [ar1 intercept ar2]
  def self.diff_inter(ar1,ar2)
    diff, inter = [], []
    ar1.each do |el|
      if ar2.index(el)==nil
        diff << el
      else
        inter << el
      end
    end
    [diff,inter]
  end
end
