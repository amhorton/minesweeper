class Minesweeper

  attr_reader :game

  def initialize
    @game = Board.new
    @game.populate
  end

  def display
    display_board = @game.board.map do |row|
      row.map do |tile|
        if tile.flagged
          tile = :FFF
        elsif tile.revealed
          if tile.bombed
            tile = :BBB
          elsif tile.bomb_adjacent?
            tile = tile.neighbor_bomb_count.to_s.to_sym
          else
            :___
          end
        else
          tile = :xxx
        end
      end
    end

    p display_board

  end

  def make_move
    puts "Please enter X coordinate and then Y coordinate: "
    x = gets.chomp
    y = gets.chomp

    coords = [x,y]

    puts "REVEAL or FLAG?"
    choice = gets.chomp.downcase

    if choice == "reveal"
      @game.board.reveal(coords) unless @game.board.tile(coords).bombed
    else
      @game.board.flag(coords)
    end

  end

  def won?
    won = true

    @game.board.each do |row|
      row.each do |tile|
        if tile.bombed && !tile.flagged
          won = false
        end
      end
    end

    won
  end

  def lost?
    lost = false

    @game.board.each do |row|
      row.each do |tile|
        if tile.revealed && tile.bombed
          lost = true
        end
      end
    end

    lost
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
    @board.each_index do |rows_index|
      @board[rows_index].each_index do |cols_index|
       @board[rows_index][cols_index] = Tile.new(self, [cols_index,rows_index])
      end
    end
  end

  def reveal(coords)

    current = self.board[coords[1]][coords[0]]

    all_seen_tiles = []

    queue = [current]

    until queue.empty?

      current = queue.shift

      if current.bomb_adjacent? || current.flag_adjacent?
        current.revealed = true
        all_seen_tiles << current
      else
        current.revealed = true
        queue += current.neighbors.select {|tile| !tile.revealed}
      end

    end

  end

  def flag(coords)
    @board[coords[1]][coords[0]].flagged = true
  end

end

class Tile

  attr_accessor :flagged, :revealed, :coords, :board

  attr_reader :bombed

  def initialize(board, coords)
    @coords = coords
    @board = board
    @revealed = false
    @flagged = false
    @bombed = false
    a = [1,2,3,4,5,6,7,8].sample
    @bombed = true if a == 6
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

our_game = Minesweeper.new

our_game.game.reveal([4,4])

our_game.display

#p our_game.game.tile([4,5]).neighbor_bomb_count