ROWS = 8

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(ROWS) { Array.new(ROWS) }
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
      piece.new([0, i], self, :b)
      Pawn.new([1, i], self, :b)
      Pawn.new([6, i], self, :w)
      piece.new([7, i], self, :w)
    end
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos,piece)
    x, y = pos[0], pos[1]
    @board[x][y] = piece
  end

  def display
    @board.each_with_index do |row, row_index|
      row_index.even? ? switch = true : switch = false

      row.each_with_index do |col, col_index|
        switch ? color = :white : color = :light_black
        if col.nil?
          print " ".colorize(:background => color)
        else
          print col.display_token.colorize(:background => color)
        end
        switch = !switch
      end.join(" ")
      puts
    end
    nil
  end

  def mid_move_display(peice_origin)
    @board.each_with_index do |row, row_index|
      row_index.even? ? switch = true : switch = false

      row.each_with_index do |col, col_index|
        switch ? color = :white : color = :light_black
        if col.nil?
          print " ".colorize(:background => color)
        elsif col.pos == peice_origin
          print col.display_token.colorize(:background => color).blink
        else
          print col.display_token.colorize(:background => color)
        end
        switch = !switch
      end.join(" ")
      puts
    end
    nil
  end

  def in_check?(color)
    flattened_board = @board.flatten

    king_pos = nil
    opponents = []

    flattened_board.each_with_index do |piece, i|
      next if piece.nil?

      king_pos = flattened_board[i].pos if piece.class == King && piece.color == color
      opponents << flattened_board[i] if piece.color != color
    end

    opponents.any? do |opponent_piece|
      opponent_piece.moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    in_check?(color) && no_valid_moves?(color)
  end

  def tie?
    @board.flatten.all? do |piece|
      piece.is_a?(King)
    end
  end



  def no_valid_moves?(color)

flattened_board = @board.flatten

    player_pieces = flattened_board.select do |current_piece|
       !current_piece.nil? && current_piece.color == color
    end

    possible_moves = []
    player_pieces.each do |piece|
      possible_moves += piece.valid_moves
    end

    possible_moves.empty?
  end

  def move!(start_pos, end_pos) #DO NOT TOUCH!!!
    piece_to_move = self[start_pos]
    self[end_pos], self[start_pos] = self[start_pos], nil
    piece_to_move.pos = end_pos
  end

  def move(start_pos, end_pos)
    piece_to_move = self[start_pos]

    if piece_to_move.nil?
      raise ArgumentError.new "No piece at start position"
    end

    if piece_to_move.move_into_check?(end_pos)
      raise ArgumentError.new "Move will leave you in check"
    end

    unless piece_to_move.valid_moves.include?(end_pos)
      raise ArgumentError.new "Illegal end position"
    end

    piece_to_move.moved = true if piece_to_move.class == Pawn && !piece_to_move.moved?

    self[end_pos], self[start_pos] = piece_to_move, nil
    piece_to_move.pos = end_pos
  end



end
