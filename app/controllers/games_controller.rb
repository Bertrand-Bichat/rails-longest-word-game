require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << Array('A'..'Z').sample
    end
  end

  def score
    word = params['word'].upcase
    @score = if included?(word, params['token'])
               if english_word?(word)
                 [compute_score(word), "Congratulations! #{word} is a valid English word!"]
               else
                 [0, "Sorry but #{word} does not seem to be a valid English word..."]
               end
             else
               str = ''
               params['token'].chars.each { |letter| str = str + letter + ',' }
               [0, "Sorry but #{word} can't be built out of #{str.delete_suffix(',')}"]
             end
  end

  private

  def included?(word, array)
    word.chars.all? { |letter| word.count(letter) <= array.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compute_score(word)
    word.size
  end
end
