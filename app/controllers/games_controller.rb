# frozen_string_literal: true

require 'date'
require 'open-uri'
require 'json'

# controller shit
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    input = JSON.parse(params[:input])
    time = DateTime.now.to_f - DateTime.parse(params[:starttime]).to_f
    @score = return_score(params[:answer], time)
    @message = message_return(params[:answer], input)
  end

  def message_return(attempt, grid)
    if in_grid(attempt, grid)
      an_english_word?(attempt)['found'] == true ? message1(attempt) : message2(attempt)
    else
      message3(attempt, grid)
    end
  end

  def message1(attempt)
    ['Congratulations', " #{attempt.upcase}", ' is a valid English word!']
  end

  def message2(attempt)
    ['Sorry but', attempt.upcase.to_s, 'does not seem to be a valid English word']
  end

  def message3(attempt, grid)
    ['Sorry but', " #{attempt.upcase}", "can't be bult out of #{grid.join(', ')}"]
  end

  def in_grid(attempt, grid)
    wrong = attempt.upcase.chars.difference(grid).empty?
    attempt.each_char { |c| wrong = false if attempt.count(c) > grid.count(c.upcase) }
  end

  def return_score(attempt, time)
    word = an_english_word?(attempt)
    word['found'] == true ? (word['length'] - (time / 10)).round(2) : 0
  end

  def an_english_word?(attempt)
    JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
  end
end
