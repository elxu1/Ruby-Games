require './board.rb'
require 'byebug'

class Game
  def initialize
    @board = Board.from_file('./sudoku1_almost.txt')
  end

  def play
    while !@board.solved?
      @board.render
      input = prompt
      @board.update(input["position"], input["value"])
    end
    @board.render
    puts "Congratulations!"
  end

  def prompt
    puts "Enter a position"
    position = gets.chomp.split(",")
    position.map! { |coord| coord.to_i }
    puts "Enter a value"
    value = gets.chomp.to_i
    return {
      "position" => position,
      "value" => value
    }
  end
end