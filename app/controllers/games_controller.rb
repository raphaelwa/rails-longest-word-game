class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ("A".."Z").to_a.sample
    end
  end

  def score
    require 'open-uri'
    require 'json'
    @answer = params[:reponse]
    @result = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@answer}").read)
    @grid = params[:letters]
    @test = final_check(@result, @answer, @grid)
  end

private

  def check_word(result)
    if result["found"] == true
      return true
    else
      return false
    end
  end

  def check_grid(word, grid)
    word = word.upcase.chars
    grid = grid.split(//)
    word.all? { |letter| grid.include?(letter) }
  end

  def check_grid_uniq(word, grid)
    grid = grid.split(//)
    word = word.upcase.chars
    word.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
    return true
  end

  def final_check(result, word, grid)
    if check_word(result) && check_grid(word, grid) && check_grid_uniq(word, grid) == true
      "GG, tu as marquay #{word.length} points"
    elsif check_word(result) == false
      "Ce mot n'existe pas"
    elsif check_grid(word, grid) == false
      "Ce mot n'est pas dans la grille"
    else
      "Arrete d'utiliser plusieurs fois la même lettre maggle"
    end
  end
end
