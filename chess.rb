class Piece
  attr_accessor :pos, :board

  def initialize(pos)
    @pos = pos
    @board = Array.new(8) { Array.new(8) } #temp: for testing
  end
end

class SlidingPiece < Piece
  def moves
    # calls on move_dirs



    # return an array of places a Piece can move to
  end


end

class Bishop < SlidingPiece
  def move_dirs
    # diagonal
  end
end

class Rook < SlidingPiece
  def move_dirs
    #horizontal,vertical
  end
end

class Queen < SlidingPiece
  def move_dirs
    # horizontal, vertical, diagonal
  end
end

class SteppingPiece < Piece

end

#Class Pawn < Piece