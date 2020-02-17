require_relative './player.rb'
require 'byebug'

class Game
  attr_reader :current_player, :previous_player, :losses

  def initialize(players)
    @players = players
    @fragment = ""
    @current_player = @players[0]
    @current_idx = 0
    @dictionary = File.read('./dictionary.txt').split
    @losses = Hash.new(0)
  end

  def play_round
    while !@dictionary.include?(@fragment)
      take_turn(@current_player)
      next_player!
    end
    puts "Game over, the word is: #{@fragment}"
    @losses[@previous_player] += 1
  end

  def next_player!
    @previous_player = @current_player
    @current_idx = (@current_idx + 1) % @players.length
    @current_player = @players[@current_idx]
  end

  def take_turn(player)
    valid = false
    while (!valid)
      puts "The current fragment is: #{@fragment}"
      puts "#{@current_player.name}'s guess: "
      guess = @current_player.guess
      valid = valid_play?(guess)
      if(!valid)
        @current_player.alert_invalid_guess
      end
    end
    @fragment << guess
  end

  def valid_play?(string)
    is_letter = string =~ /[[:alpha:]]/
    return false if !is_letter || string.length != 1

    new_frag = @fragment + string.downcase
    return @dictionary.any? { |word| word.start_with?(new_frag) }
  end

  def record(player)
    losses = @losses[player]
    ghost = "GHOST"[0...losses]
    return "#{player.name} has #{ghost}."
  end

  def display_standings
    @players.each do |player|
      puts record(player)
    end
  end

  def run
    while @players.length > 1
      @fragment = ""
      display_standings
      play_round

      @losses.each do |player, loss|
        if loss >= 5
          @players.delete(player)
        end
      end
    end
    display_standings
  end
end