require './piece.rb'
require './board.rb'
require 'debugger'
class Game

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:w)
    @player2 = HumanPlayer.new(:b)
  end


  def display_board
    puts @board.display
  end

  def play

    loop do
      display_board

      start_pos, end_pos = @player1.play_turn

      @board.move(start_pos, end_pos)

      display_board
      start_pos, end_pos = @player2.play_turn
      @board.move(start_pos, end_pos)
    end

  end

end


class HumanPlayer
  def initialize(color)
    @color = color
  end

  def play_turn
    puts "Where do you want to move? Input example: B2,C4"
    start_pos, end_pos = gets.chomp.split(",")

    [convert_entry(start_pos), convert_entry(end_pos)]
    # begin / rescue / retry
  end

  def convert_entry(pos)
    [8-Integer(pos[1]),pos[0].downcase.ord-97]
  end

end

g = Game.new
g.play