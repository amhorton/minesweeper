class Minesweeper

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
    @board.each do |rows|
      @board.each do |cols|
       @board[cols][rows] = Tile.new(self, [cols,rows])
      end
    end
  end


end

class Tile

  attr_accessor :bombed?, :flagged?, :revealed?

  def initialize(board, coords)
    @coords = coords
    @board = board
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

  def reveal
    revealed? = true
  end

  def neighbors
    my_neighbors = []

    NEIGHBOR.each do |neighbor|
      my_neighbors << [(self.coords.first - neighbor.first), (self.coords.last - neighbor.last)]
    end

    my_neighbors.select { |coord| coord.none? { |num| num > 8 || num < 0 }

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

end