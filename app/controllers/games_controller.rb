require'open-uri'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @letters = []
    alphabet = ('A'..'Z').to_a
    10.times do
      @letters << alphabet.sample
    end
    @letters
  end

  def score
    word = params[:word]
    start_time = Time.parse(params[:start_time])
    end_time = Time.now
    grid = params[:grid].split('')


    if test1(word, grid).zero?
      @score = 0
      @message = 'the word is using letters not in the grid'
      @time = 0
    else
      # TEST 2: need to check if the word is in the word dictionary from LeWagon
      url = "https://wagon-dictionary.herokuapp.com/#{word}"
      check = JSON.parse(open(url).read)
      if check['found'] == false
        @score= 0
        @message= 'not an english word'
        @time= 0
      else
        @time = end_time - start_time
        @score = (100 / @time) + word.size
        @message = 'Well Done'
      end
    end
  end

  def test1(attempt, grid)
    # TEST 1: need to validate that the word uses only the characters of the grid
    attempt_arr = attempt.upcase.split('')
    until attempt_arr.empty?
      if grid.include? attempt_arr[0]
        grid.delete_at(grid.index(attempt_arr[0]))
        attempt_arr.delete_at(0)
      else
        return 0
      end
    end
    1
  end
end
