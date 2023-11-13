require 'open-uri'
class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]
    @valid_word = included?(@word, @letters) && english_word?(@word)

    if @valid_word
      @score = compute_score(@word)
      session[:total_score] = session[:total_score].to_i + @score
    else
      @score = 0
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def compute_score(word)
    word.length
  end
end
