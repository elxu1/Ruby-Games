class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def guess
    guess = nil
    while guess == nil
      guess = gets.chomp.downcase
    end
    return guess
  end

  def alert_invalid_guess
    puts "Invalid guess!"
  end
end