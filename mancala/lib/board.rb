require_relative 'player'

class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @player1 = Player.new(name1, 1)
    @player2 = Player.new(name2, 2)
    @cups = Array.new(14) { Array.new }
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    (0..13).each do |cup|
      next if cup == 6 || cup == 13
      4.times { @cups[cup] << :stone }
    end
  end

  def valid_move?(start_pos)
    in_range = (start_pos.between?(0,13))
    raise "Invalid starting cup" unless in_range

    is_empty = @cups[start_pos].empty?
    raise "Starting cup is empty" if is_empty
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos].length
    @cups[start_pos] = []

    # Distribute the stones
    current_pos = start_pos
    while stones > 0
      current_pos += 1
      current_pos %= 14
      
      # Skip the opponent's store
      opponent_store = current_player_name == @player1.name ? 13 : 6
      next if current_pos == opponent_store

      # Distribute stone
      stones -= 1
      @cups[current_pos] << :stone
    end

    render
    next_turn(current_pos)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    return :prompt if ending_cup_idx == 6 || ending_cup_idx == 13
    return :switch if @cups[ending_cup_idx].length == 1
    return ending_cup_idx
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    first_side_empty = @cups[0..5].all? { |cup| cup.empty? }
    second_side_empty = @cups[7..12].all? { |cup| cup.empty? }
    return first_side_empty || second_side_empty
  end

  def winner
    return :draw if @cups[6] == @cups[13]
    return @cups[6].length > @cups[13].length ? @player1.name : @player2.name
  end
end
