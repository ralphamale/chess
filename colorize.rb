require 'colorize'


#board = Array.new(8) { Array.new(8)  }

board = Array.new(8) do |row|
      Array.new(8) { "  " }
end
#
#
# board.each_with_index do |row, row_index|
#   row_index.even? ? switch = true : switch = false
#
#   row.each_with_index do |col, col_index|
#     switch ? color = :red : color = :blue
#     print col.colorize(:background => color)
#     switch = !switch
#   end.join("")
#   puts
# end

puts "This is blue text on red".on_red.blink
puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)