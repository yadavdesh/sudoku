class Sudoku
  SIZE = 9
  NUMBERS = (1..9).to_a

  def initialize
    @board = Array.new(SIZE) { Array.new(SIZE, nil) }
  end

  def [](x, y)
    @board[y][x]
  end

  def []=(x, y, value)
    raise "#{value} is not allowed in the row #{y}" unless allowed_in_row(y).include?(value)
    raise "#{value} is not allowed in the column #{x}" unless allowed_in_column(x).include?(value)
    raise "#{value} is not allowed in the square at #{x}, #{y}" unless allowed_in_square(x, y).include?(value)
    @board[y][x] = value
  end

  def to_s
    @board.map { |row| row.map { |x| if x.nil?; '-'; else x end }.join(' ') }.join("\n")
  end

  def row(y)
    Array.new(@board[y])
  end

  def column(x)
    @board.map { |row| row[x] }
  end

  def allowed_in_row(y)
    (NUMBERS - row(y)).uniq << nil
  end

  def allowed_in_column(x)
    (NUMBERS - column(x)).uniq << nil
  end

def allowed_in_square(x, y)
  sx = 3 * (x / 3)
  sy = 3 * (y / 3)
  square = []

  3.times do |i|
    3.times do |j|
      square << @board[sy + j][sx + i]
    end
  end

  (NUMBERS - square).uniq << nil
end

def allowed(x, y)
  allowed_in_row(y) & allowed_in_column(x) & allowed_in_square(x, y)
end

def empty
  result = []

  9.times do |y|
    9.times do |x|
      result << [x, y] if self[x, y].nil?
    end
  end

  result
end

def solved?
  empty.empty?
end
end

sudoku = Sudoku.new
9.times do |y|
  gets.chop.split(' ').each_with_index do |value, x|
    sudoku[x, y] = value.to_i unless value == '-'
  end
end

def solve(sudoku)
  return true if sudoku.solved?

  x, y = sudoku.empty.first
  allowed = sudoku.allowed(x, y).compact

  while !allowed.empty?
    sudoku[x, y] = allowed.shift

    begin
      return true if solve(sudoku)
    rescue Exception => e
    end

    sudoku[x, y] = nil
  end

  return false
end

if solve(sudoku)
  puts sudoku
else
  puts "unsolvable"
end
