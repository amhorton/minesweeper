class Board

  attr_accessor :board

  attr_reader :difficulty

  def initialize(board_dimension = 9, difficulty = 'easy')
    @board = Array.new(board_dimension) { Array.new(board_dimension)}
    @difficulty = difficulty
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

      if current.bomb_adjacent? || current.flag_adjacent? || current.bombed
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