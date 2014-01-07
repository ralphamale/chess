ROWS = 8
require 'debugger'

class Board


  attr_accessor :board

  def initialize
    @board = Array.new(ROWS) { Array.new(ROWS) }
    #generate_board
  end

  def dup
    duped_board = Board.new
      self.board.flatten.each do |piece|
        next if piece.nil?

        piece_class = piece.class
        piece_class.new(piece.pos.dup, duped_board, piece.color)
      end

      duped_board

  end

  def generate_board

    layout_array = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    layout_array.each_with_index do |piece, i|
      piece.new([0,i], self, :b)
      # Pawn.new([1,i],self,:b)
#       Pawn.new(6,i),self,:w)
      piece.new([7,i], self, :w)
    end


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
#    debugger
    flattened_board = @board.flatten

    king_pos = nil
    opponents = []

    flattened_board.each_with_index do |piece, i|
      next if piece.nil?
      king_pos = flattened_board[i].pos if piece.class == King && piece.color == color
      opponents << flattened_board[i] if piece.color != color
    end

 #   debugger

    opponents.any? do |opponent_piece|
      opponent_piece.moves.include?(king_pos)
    end
  end

  def move(start_pos, end_pos)

    piece_to_move = self[start_pos]

    if piece_to_move.nil?
      raise ArgumentError.new "No piece at start position"
    end

    unless piece_to_move.moves.include?(end_pos)
      raise ArgumentError.new "Illegal end position"
    end


    self[end_pos], self[start_pos] = piece_to_move, nil

    piece_to_move.pos = end_pos
    # raise

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

  def move_into_check?(end_pos)
    duped_board = @board.dup
    duped_board.move(self.pos, end_pos)
    duped_board.in_check?(@color)

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
    possible_moves

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

  def move_dirs
    if self.color == :w
      return [0,1]
    else
      return [0,-1]
    end
  end
end