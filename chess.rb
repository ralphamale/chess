require './piece.rb'
require './board.rb'
require 'debugger'
require 'colorize'

class Game
  attr_reader :players, :turn

  def initialize(player1, player2)
    @board = Board.new
    @board.generate_board
    @players = { w: player1, b: player2 }
    @turn = :w
  end

  def display_board
    puts @board.display
  end

  def play
    loop do

      display_board

        begin
          current_player = self.players[self.turn]
          start_pos, end_pos = current_player.play_turn
          @board.move(start_pos, end_pos)

        rescue ArgumentError => e # ArgumentError lives in @board.move

          puts "Error was: #{e.message}"
          puts "Please try again"


          retry
        end
        @turn = ((self.turn == :w) ? :b : :w)

      break if @board.checkmate?(@turn)
      return "Draw!" if @board.tie?
    end

    display_board
    puts "#{self.players[self.turn].name} loses!"
  end

end


class HumanPlayer
  attr_reader :name
  def initialize(name, color)
    @name = name
    @color = color
  end

  def play_turn # possibly break out into move_from and move_to methods
    puts "Where do you want to move? Input example: B2,C4"
    start_pos, end_pos = gets.chomp.split(",")

    [convert_entry(start_pos), convert_entry(end_pos)]
  end

  def convert_entry(pos)
    [8-Integer(pos[1]),pos[0].downcase.ord-97]
  end

end


if $PROGRAM_NAME == __FILE__

  player1 = HumanPlayer.new("Alex", :w)
  player2 = HumanPlayer.new("Ralph", :b)

  g = Game.new(player1, player2)
  g.play

end