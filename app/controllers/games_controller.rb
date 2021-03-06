require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    6.times { @letters << ('A'..'Z').to_a[rand(26)] }
    4.times { @letters << ['A', 'E', 'I', 'O', 'U'].sample(1).first }
  end

  def score
    @attempt = params[:attempt].upcase.chars
    @letters = params[:letters].chars
    if in_grid?(@attempt, @letters) && english?(@attempt)
      @result = "Congratulations! `#{@attempt.join.capitalize}` is a valid English word"
    elsif !in_grid?(@attempt, @letters)
      @result = "Sorry but `#{@attempt.join.capitalize}` can't be built out of #{@letters.join}"
    else
      @result = "Sorry but `#{@attempt.join.capitalize}` does not seem to be a valid English word.."
    end
  end

  private

  def in_grid?(attempt, letters)
    attempt.all? { |letter| attempt.count(letter) <= letters.count(letter) }
  end

  def english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.join}"
    attempt_serialized = open(url).read
    attempt = JSON.parse(attempt_serialized)
    attempt['found']
  end
end
