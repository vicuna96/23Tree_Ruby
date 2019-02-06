require 'json'

class Spell

  def initialize(params)
    @classification = params["Classification"]
    @effect = params["Effect"]
    @name = params["Spell(Lower)"]
    @formatted_name = params["Spell"]
  end

  attr_reader :classification, :effect, :name, :formatted_name

  def self.data
    path = 'data/spells.json'
    file = File.read(path)
    JSON.parse(file)
  end

  def self.random
    new(data.sample)
  end

  def self.effects
    data.map{|el| el["Effect"]}
  end

  # These two methods are used to validate answers
  def self.is_spell_name?(str)
    data.index { |el| el["Spell(Lower)"] == (str.downcase) }
  end

  def self.is_spell_name_for_effect?(name, effect)
    data.index { |el| el["Spell(Lower)"] == name && el["Effect"] == effect }
  end

  # To get access to the collaborative repository, complete the methods below.

  # Spell 1: Reverse
  # This instance method should return the reversed name of a spell
  # Tests: `bundle exec rspec -t reverse .`
  def reverse_name
    @name.reverse
  end

  # Spell 2: Counter
  # This instance method should return the number
  # (integer) of mentions of the spell.
  # Tests: `bundle exec rspec -t counter .`
  def mention_count
    count = 0
    Mention.data.each do |spell|
      if spell["Spell"] == @name
        count+=1
      end
    end
    count
  end

  # Spell 3: Letter
  # This instance method should return an array of all spell names
  # which start with the same first letter as the spell's name
  # Tests: `bundle exec rspec -t letter .`
  def names_with_same_first_letter
    spells = []
    Spell.data.each do |el|
      if @name[0]==el["Spell(Lower)"][0]
        spells << el["Spell(Lower)"]
      end
    end
    spells
  end

  # Spell 4: Lookup
  # This class method takes a Mention object and
  # returns a Spell object with the same name.
  # If none are found it should return nil.
  # Tests: `bundle exec rspec -t lookup .`
  def self.find_by_mention(mention)
    i, data = 0 , Spell.data
    until data[i]==nil||data[i]["Spell(Lower)"]==mention.name
      i+=1
    end
    if data[i]!= nil
      Spell.new(data[i])
    else
      nil
    end
  end

  # This method returns [true] if [word] is a palindrome
  # require: [word] is a string
  def self.is_palindrome(word)
    if word.empty? || word.length==1
      true
    else
      word[0]==word[-1]&&Spell.is_palindrome(word.sub(1,word.length-2))
    end
  end

def self.hash_letters(word)
  hash=Hash.new
  for i in 0...word.length
    Factor.insert_hash_l(hash,word[i],1,lambda {hash[word[i]]+1})
  end
  hash
end

# This method returns [true] if [word1] is a permutation of the letter of [word2]
def self.is_permutation?(word1,word2)
  Spell.hash_letters(word1)==Spell.hash_letters(word2)
end

# This method returns a [spell] whose name is a permutation of [word] if there
# exists such a spell in spell.rb, or nil if there is no such spell
def self.find_permutation(word)
  i, data = 0, Spell.data
  until Spell.is_permutation?(data[i]["Spell(Lower)"],word)
    i+=1
    break if data[i]==nil
  end
  data[i]
end

# This method returns a permutation of the string [word]
def self.permute_word(word)
  4.times do
    i, j = rand(word.length), rand(word.length)
    letter = word[i]
    word[i]=word[j]
    word[j]=letter
  end
  word
end

# This instance method returns a permutation of the spell's name
def permute
  Spell.permute_word(@name)
end

  # This method returns a [hash] that maps [words] to their respective [number]
  # of ocurrances in the spell effects
  def self.words
    Factor.words_l(lambda{Spell.data}, "Effect")
  end

  # This method returns an order [array] of [word,number of ocurrances] pairs
  # of the words used to describe spell effects
  def self.word_frequency
    Factor.word_frequency(lambda {Spell}, "Effect")
  end

  # This method returns a [hash] that maps [numbers] to lists of [words],
  # describing the number of ocurrances of words in the effect descriptions of spells
  def self.by_frequency
    Factor.by_frequency(lambda {Mention})
  end

  # This instance method returns the classification of the spell
  def get_type
    @classification
  end

  # This method should return a 23-Tree where the keys are the [spell names] and
  # the values are the corresponding [spells]
  def self.tree
    Factor.tree(lambda {Spell},"Spell")
  end

  # This method should return a hash with the lowercase spell names as keys
  # and the corresponding instance of spell as values
  def self.hash
    Factor.hash(lambda {Spell},"Spell")
  end

  # This method returns an array containing the spells from secret.json
  def self.secret
    Factor.secret("spells")
  end
  # This method returns an array containing the spell names from spell.json
  def self.spell_array
    Factor.arrays(lambda{Spell.data},"Spell")
  end
  # This method returns an array containing the spell names from secret.json
  def self.secret_array
    Factor.arrays(lambda{Spell.secret},"Spell")
  end

  # This method returns an [array] with [0] all the spells contained in spell.json
  # and not in secret.json, and [1] all the spells in both files
  def self.diff_inter
    Factor.diff_inter(spell_array,secret_array)
  end
end
