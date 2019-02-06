require 'json'
require 'set'

class Mention

  def initialize(params)
    @book = params["Book"]
    @quote = params["Concordance"]
    @position = params["Position"]
    @name = params["Spell"]
  end

  attr_reader :book, :quote, :position, :name

  def self.data
    path = 'data/mentions.json'
    file = File.read(path)
    JSON.parse(file)
  end

  def self.random
    new(data.sample)
  end

  # This method returns a [hash] that maps [words] to their respective [number]
  # of ocurrances in the spell mentions
  def self.words
    Factor.words_l(lambda{Mention.data}, "Concordance")
  end

  # This method returns an order [array] of [word,number of ocurrances] pairs
  # of the words used in spell mentions
  def self.word_frequency
    Factor.word_frequency(lambda{Mention}, "Concordance")
  end

  # This method returns a [hash] that maps [numbers] to lists of [words],
  # describing the number of ocurrances of words in all mentions
  def self.by_frequency
    Factor.by_frequency(lambda {Mention})
  end

  # This method should return a 23-Tree where the keys are the [spell names] and
  # the values are the corresponding [mentions]
  def self.tree
    Factor.tree(lambda {Mention}, "Spell")
  end

  # This method should return a hash with the lowercase [spell names] as keys
  # and the corresponding instances of [mention] as values
  def self.hash
    Factor.hash(lambda{Mention}, "Spell")
  end

  # This method returns an array containing the mentions from secret.json
  def self.secret
    Factor.secret(:mentions)
  end

  # This method returns an array containing the spell names from mention.json
  def self.mention_array
    Factor.arrays(lambda{Mention.data},:Spell)
  end

  # This method returns an array containing the spell names from secret.json
  def self.secret_array
    Factor.arrays(lambda{Mention.secret},:Spell)
  end

  # This method returns an [array] with [0] all the spells contained in mention.json
  # and not in secret.json, and [1] all the spells names in both files 
  def self.diff_inter
    Factor.diff_inter(mention_array,mention_array)
  end

end
