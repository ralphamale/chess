require 'colorize'


#board = Array.new(8) { Array.new(8)  }

board = Array.new(8) do |row|
      Array.new(8) { "  " }
end


@board =  board.map do |row|
  row.map do |col|
    col.colorize(:red)
  end.join("   ")
end.join("\n")

puts @board

# puts "red background".colorize(:color => :blue)