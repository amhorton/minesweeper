class Minesweeper

  def initialize
    @board = Board.new
    @board.populate
  end

  def display
    display_board = @board.board.map do |row|
      row.map do |tile|
        if tile.flagged
          tile = :F
        elsif tile.revealed
          if tile.bombed?
            tile = :B
          elsif tile.bomb_adjacent?
            tile = tile.neighbor_bomb_count
          else
            :_
          end
        else
          tile = :*
        end
      end
    end

    p display_board

  end

  def make_move
    puts "Please enter X coordinate and then Y coordinate: "
    x = gets.chomp
    y = gets.chomp

    coord = [x,y]

    puts "REVEAL or FLAG?"
    choice = gets.chomp

    move = [coord,choice]
  end

  def won?
    #checks if all tiles that have a bomb are flagged
  end

  def lost?
    #checks if any tiles that have bombs are revealed but not flagged
  end





  def play









  end



end

class Board

  attr_accessor :board

  def initialize(board_dimension = 9)
    @board = Array.new(board_dimension) { Array.new(board_dimension)}
  end

  def tile(coords)
    @board[coords.last][coords.first]
  end

  def populate
    @board.each_index do |rows|
      @board.each_index do |cols|
       @board[cols][rows] = Tile.new(self, [cols,rows])
      end
    end
  end


end

class Tile

  attr_accessor :bombed, :flagged, :revealed

  def initialize(board, coords)
    @coords = coords
    @board = board
    @revealed = false
    @flagged = false
    @bombed = false
    a = [1,2,3,4].sample
    @bombed = true if a == 1
  end

  NEIGHBOR = [[1,1],
              [0,1],
              [-1,-1],
              [0,-1],
              [1,0],
              [-1,0],
              [-1,1],
              [1,-1]
            ]

  # def reveal
#     @revealed = true
#   end
#
#   def flag
#     @flagged = true
#   end

  # def bomb
#     #@bomb = true
#   end

  def neighbors
    my_neighbors = []

    NEIGHBOR.each do |neighbor|
      my_neighbors << [(self.coords.first - neighbor.first), (self.coords.last - neighbor.last)]
    end

    my_neighbors.select { |coord| coord.none? { |num| num > 8 || num < 0 }}

    my_neighbors = my_neighbors.map { |coord| self.board.tile(coord) }
  end

  def neighbor_bomb_count
    adj_bombs = 0

    self.neighbors.each do |neighbor|
      if neighbor.bombed?
        adj_bombs += 1
      end
    end

    adj_bombs
  end

  def bomb_adjacent?
    self.neighbors.any? { |neighbor| neighbord.bombed }
  end

end

our_game = Minesweeper.new

our_game.display