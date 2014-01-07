ROWS = 8
require 'debugger'

class Board

  attr_accessor :board

  def initialize
    @board = Array.new(ROWS) { Array.new(ROWS) }
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos,piece)
    x,y = pos[0], pos[1]
    @board[x][y] = piece
  end

  def display
    @board.each do |row|
      puts row.join(" ")
    end
  end

  def in_check?(color)


    # returns if player is in check
  end
   #

  def move(start_pos, end_pos)

  end



end


class Piece
  attr_accessor :pos, :board, :color #add team functionality

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
    @board[pos] = self
  end
end

class SlidingPiece < Piece

  # def neighbors
  #   adjacent_coords = DELTAS.map do |(dx, dy)|
  #     [pos[0] + dx, pos[1] + dy]
  #   end.select do |row, col|
  #     [row, col].all? do |coord|
  #       coord.between?(0, @board.grid_size - 1)
  #     end
  #   end
  #
  #   adjacent_coords.map { |pos| @board[pos] }
  # end

  def moves
    # possible_moves = []
    # i = 1
    # while i < ROWS
    #   possible_moves += move_dirs.each do |(dx, dy)|
    #     # break if same color piece
    #     # break if opposing color piece
    #
    #     [pos[0] + (i*dx), pos[1] + (i*dy)]
    #   end
    #
    #   i += 1
    # end
    possible_moves = []
    move_dirs.each do |(dx, dy)|
      (1).upto(7) do |i|
        #debugger
        current_pos = [pos[0] + (i*dx), pos[1] + (i*dy)]

        break unless current_pos.all? { |coord| coord.between?(0,ROWS-1)}
        break if (@board[current_pos] && @board[current_pos].color == self.color)

        possible_moves << current_pos

        break if (@board[current_pos] && @board[current_pos].color != self.color)
      end
    end

  end

      #adjacent_coords.map { |pos| @board[pos] } <- fr/ minesweep
      # return an array of places a Piece can move to

end

class Bishop < SlidingPiece
  def move_dirs
    [[1,1], [1, -1], [-1, -1], [-1, 1]]
  end
end

class Rook < SlidingPiece
  def move_dirs
    [[1,0], [-1, 0], [0, -1], [0, 1]]
  end
end

class Queen < SlidingPiece

  def move_dirs
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1],
    [1, -1], [1, 0], [1, 1]]
  end
end

class SteppingPiece < Piece
  def moves

    #
    # break if (@board[current_pos] && @board[current_pos].color == self.color)
    #
    # possible_moves << current_pos
    #
    # break if (@board[current_pos] && @board[current_pos].color != self.color)

    possible_moves = []
      possible_moves += move_dirs.map do |(dx, dy)|
        [pos[0] + dx, pos[1] + dy]
      end.select do |row, col|
      [row, col].all? do |coord|
        coord.between?(0, ROWS-1)
      end
    end

    possible_moves.delete_if do |current_pos|
      @board[current_pos] && @board[current_pos].color == self.color
    end


  end
end

class Knight < SteppingPiece
  def move_dirs
    [[1,2], [2,1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end

class King < SteppingPiece
  def move_dirs
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1],
    [1, -1], [1, 0], [1, 1]]
  end
end


class Pawn < Piece
end