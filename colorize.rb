require 'colorize'


#board = Array.new(8) { Array.new(8)  }

board = Array.new(8) do |row|
      Array.new(8) { "  " }
end


puts board.each_with_index do |row|
  p
  row.each_with_index do |col|
    if board[row].
  end.join("")
end.join("\n")

puts @board

# puts "red background".colorize(:color => :blue)