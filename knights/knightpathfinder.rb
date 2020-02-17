require_relative './tree_node.rb'
require 'byebug'

class KnightPathFinder
  def initialize(pos)
    @root_node = PolyTreeNode.new(pos)
    @considered_positions = [pos]
  end

  def self.valid_moves(pos)
    offsets = [1,2]
    factors = [1,-1]
    solutions = []

    # List all possible coordinates
    offsets.each do |first_offset|
      offsets.each do |second_offset|
        next if first_offset == second_offset
        factors.each do |first_factor|
          factors.each do |second_factor|
            first_coord = pos[0] + (first_offset * first_factor)
            second_coord = pos[1] + (second_offset * second_factor)
            solutions << [first_coord, second_coord]
          end
        end
      end
    end

    # Filter out positions off the board
    solutions.reject do |coordinates|
      x = coordinates[0]
      y = coordinates[1]
      (x < 0 || x > 7) || (y < 0 || y > 7)
    end
  end

  def new_move_positions(pos)
    possible_moves = KnightPathFinder.valid_moves(pos)

    # Filter out moves already considered before adding
    possible_moves.delete_if { |move| @considered_positions.include?(move) }
    @considered_positions += possible_moves
    return possible_moves
  end

  def build_move_tree
    # Begin the queue with the root
    queue = [@root_node]

    while !queue.empty?
      # Dequeue and get new positions
      node = queue.shift
      new_positions = new_move_positions(node.value)

      # Add the new positions as children of the node
      new_positions.map! { |position| PolyTreeNode.new(position) }
      new_positions.each do |new_node| 
        node.add_child(new_node)

        # Add new position nodes back into the queue
        queue.push(new_node)
      end
    end
  end

  def find_path(end_pos)
    target = @root_node.dfs(end_pos)
    path = trace_path_back(target)
  end

  def trace_path_back(node)
    return [node.value] if node.parent == nil
    return trace_path_back(node.parent) + [node.value]
  end
end