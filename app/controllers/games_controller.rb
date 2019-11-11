require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @attempt = params[:attempt].chars
    @letters = params[:letters].chars
    if in_grid?(@attempt, @letters) && english?(@attempt)
      @result = "Congratulations! #{@attempt.join} is a valid English word"
    elsif !in_grid?(@attempt, @letters)
      @result = "Sorry but #{@attempt.join} can't be built out of #{@letters.join}"
    else
      @result = "Sorry but #{@attempt.join} does not seem to be a valid English word.."
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
