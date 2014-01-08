

class Piece
  attr_accessor :pos, :board, :color, :display_token

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
    @board[pos] = self
  end

  def move_into_check?(end_pos)
    duped_board = @board.dup
    duped_board.move!(self.pos.dup, end_pos.dup)

    duped_board.in_check?(@color)
  end

  def valid_moves
    moves.delete_if do |move|
      move_into_check?(move)
    end
  end

end

class SlidingPiece < Piece

  def moves
    possible_moves = []

    move_dirs.each do |(dx, dy)|
      (1).upto(7) do |i|

        current_pos = [pos[0] + (i * dx), pos[1] + (i * dy)]

        break unless current_pos.all? { |coord| coord.between?(0,ROWS-1)}
        break if (@board[current_pos] && @board[current_pos].color == self.color)

        possible_moves << current_pos

        break if (@board[current_pos] && @board[current_pos].color != self.color)
      end
    end
    possible_moves

  end

end

class Bishop < SlidingPiece
  def initialize(pos, board, color)
    super(pos, board, color)
    @display_token = (color == :w) ? "\u2657".encode('utf-8') : "\u265d".encode('utf-8')
  end

  def move_dirs
    [[1, 1], [1, -1], [-1, -1], [-1, 1]]
  end
end

class Rook < SlidingPiece
  def initialize(pos, board, color)
    super(pos, board, color)
    @display_token = (color == :w) ? "\u2656".encode('utf-8') : "\u265c".encode('utf-8')
  end
  def move_dirs
    [[1, 0], [-1, 0], [0, -1], [0, 1]]
  end
end

class Queen < SlidingPiece
  def initialize(pos, board, color)
    super(pos, board, color)
    @display_token = (color == :w) ? "\u2655".encode('utf-8') : "\u265b".encode('utf-8')
  end

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

  def initialize(pos, board, color)
    super(pos, board, color)
    @display_token = (color == :w) ? "\u2658".encode('utf-8') : "\u265e".encode('utf-8')
  end


  def move_dirs
    [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end

class King < SteppingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
    @display_token = (color == :w) ? "\u2654".encode('utf-8') : "\u265a".encode('utf-8')
  end

  def move_dirs
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1],
    [1, -1], [1, 0], [1, 1]]
  end
end


class Pawn < Piece
  attr_accessor :moved
  def initialize(pos, board, color)
    super(pos, board, color)
    @display_token = (color == :w) ? "\u2659".encode('utf-8') : "\u265f".encode('utf-8')
    @moved = false
  end

  def moved?
    @moved
  end

  def moves
    dx, dy = move_dirs
    multiplier = (moved? ? 1 : 2)
    possible_moves = []

    1.upto(multiplier) do |i|
      maybe_move = [pos[0] + (i * dx), pos[1] + (i * dy)]
      possible_moves << maybe_move if @board[maybe_move].nil?
    end

    [-1, 1].each do |j|
      diagonal_case = @board[[pos[0] + dx, pos[1] + j]]
      possible_moves << diagonal_case.pos if !diagonal_case.nil? && diagonal_case.color != self.color
    end

    possible_moves
  end

  def move_dirs

    return (self.color == :w ? [-1, 0] : [1, 0])
  end
end