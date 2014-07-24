
class Tile

  attr_accessor :flagged, :revealed, :coords, :board

  attr_reader :bombed

  def initialize(board, coords)
    @coords = coords
    @board = board
    @revealed = false
    @flagged = false
    @bombed = false

    if board.difficulty == "expert"
      a = [1,2,3,4].sample
      @bombed = true if a == 6
    elsif board.difficulty == "medium"
      a = [1,2,3,4,5,6].sample
      @bombed = true if a == 6
    else
      a = [1,2,3,4,5,6,7,8].sample
      @bombed = true if a == 6
    end

  end

  NEIGHBOR_COORDS = [[1,1],
              [0,1],
              [-1,-1],
              [0,-1],
              [1,0],
              [-1,0],
              [-1,1],
              [1,-1]
            ]
  def neighbors
    my_neighbors = []

    NEIGHBOR_COORDS.each do |neighbor|
      my_neighbors << [(self.coords.first - neighbor.first), (self.coords.last - neighbor.last)]
    end

    my_neighbors.select! { |coord| coord.none? { |num| num > 8 || num < 0 }}

    my_neighbors = my_neighbors.map { |coord| self.board.tile(coord) }
  end

  def neighbor_bomb_count
    adj_bombs = 0

    self.neighbors.each do |neighbor|
      if neighbor.bombed
        adj_bombs += 1
      end
    end

    adj_bombs
  end

  def bomb_adjacent?
    self.neighbors.any? { |neighbor| neighbor.bombed }
  end

  def flag_adjacent?
    self.neighbors.any? { |neighbor| neighbor.flagged }
  end

end

