

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
    duped_board.move!(self.pos, end_pos)
    duped_board.in_check?(@color)

  end

  def valid_moves
    moves.delete_if do |move| # move = position
      move_into_check?(move)  # filters out dumb moves
    end
  end

end

class SlidingPiece < Piece

  def moves

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

  def moves
    dx, dy = move_dirs

    possible_moves = [pos[0], pos[1] + dy]

    d_left = @board[pos[0] - 1, pos[1] + dy]
    d_right = @board[pos[0] + 1, pos[1] + dy]

    possible_moves << d_left if !d_left.nil? && d_left.color != self.color
    possible_moves << d_right if !d_right.nil? && d_right.color != self.color

    possible_moves
  end

  def move_dirs
    if self.color == :w
      return [0,1]
    else
      return [0,-1]
    end
  end
end