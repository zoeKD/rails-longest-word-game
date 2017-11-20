require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @letters = params[:letters]
    @attempt = params[:word]
    @result = compute_score(@attempt, @letters)
    session[:score] ||= 0
    session[:score] += @result[:score]
  end

  private

  def generate_grid(grid_size)
  # TODO: generate random grid of letters
    generate_grid = []
    grid_size.times { generate_grid << ("A".."Z").to_a.sample }
    return generate_grid
  end

  def check_in_grid?(attempt, grid)
    attempt.upcase.split("").all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
  end

  def check_dico_api(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    html_file = open(url).read
    html_doc = JSON.parse(html_file)
    return html_doc["found"]
  end

  def compute_score(attempt, grid)
    result = {}
    result[:score] = 0
    if check_dico_api(attempt) == false
      result[:message] = "does not seem to be a valid English word..."
    elsif check_in_grid?(attempt, grid)
      result[:message] = "is a valid English word!"
      result[:score] = attempt.length
    else
      result[:message] = "can't be built out of #{grid}"
    end
    return result
  end
end
