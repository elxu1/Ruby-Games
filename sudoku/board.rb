require_relative 'tile.rb'
require 'byebug'

class Board
  def initialize(grid)
    @grid = grid
  end

  def self.from_file(file)
    grid = File.read(file).split
    grid.map! do |line|
      values = line.split("")

      # Change each line into an array of tiles
      values.map! do |value|
        Tile.new(value.to_i)
      end
    end
    Board.new(grid)
  end

  def update(pos, value)
    row = pos[0]
    column = pos[1]
    tile = @grid[row][column]
    tile.value = value
  end

  def render
    status = ""
    @grid.each do |row|
      row.each do |tile|
        status += tile.to_s + " "
      end
      status += "\n"
    end
    puts status
  end

  def is_complete?(values)
    (1..9).all? do |num|
      values.include?(num)
    end
  end

  def row_solved?(row)
    values = @grid[row].map { |tile| tile.value }
    is_complete?(values)
  end

  def column_solved?(column)
    values = []
    @grid.each { |row| values << row[column].value }
    is_complete?(values)
  end

  def subgrid_solved?(subgrid)
    start_row = (subgrid / 3) * 3
    start_column = (subgrid % 3) * 3

    values = []
    (0..2).each do |row_offset|
      (0..2).each do |column_offset|
        row = start_row + row_offset
        column = start_column + column_offset
        values << @grid[row][column].value
      end
    end
    is_complete?(values)
  end

  def solved?
    (0..8).all? do |iter|
      row_solved?(iter) && column_solved?(iter) && subgrid_solved?(iter)
    end
  end
end