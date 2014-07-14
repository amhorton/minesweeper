class Minesweeper

end

class Board

  def initialize(board_dimension = 9)
    @board = Array.new(board_dimension) { Array.new(board_dimension)}
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

  end

  def neighbors
    my_neighbors = []
    NEIGHBOR.each do |neighbor|
      my_neighbors << [(self.coords.first - neighbor.first), (self.coords.last - neighbor.last)]
    end
    my_neighbors.select { |coord| coord.any? { |num| num < 8 || num > 0 }
    my_neighbors = my_neighbor.map { |coord| self.board.board.tile(coord) }
  end

  def neighbor_bomb_count

  end

end