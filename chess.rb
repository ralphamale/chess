ROWS = 8

class Piece
  attr_accessor :pos, :board

  def initialize(pos)
    @pos = pos
    @board = Array.new(8) { Array.new(8) } #temp: for testing
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
    possible_moves = []
    i = 1
    while i < ROWS
      possible_moves += move_dirs.map do |(dx, dy)|
        [pos[0] + (i*dx), pos[1] + (i*dy)]
      end

      i += 1
    end

    possible_moves.select do |row, col|
      [row, col].all? do |coord|
        coord.between?(0, ROWS-1)
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

    possible_moves = []
      possible_moves += move_dirs.map do |(dx, dy)|
        [pos[0] + dx, pos[1] + dy]
      end.select do |row, col|
      [row, col].all? do |coord|
        coord.between?(0, ROWS-1)
      end
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