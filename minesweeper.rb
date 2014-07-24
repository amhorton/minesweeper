require 'yaml'

class Minesweeper

  class MinesweeperError < StandardError
  end

  attr_reader :game

  def initialize
    @game = nil
    @leaderboard = []
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
    puts "Would you like to save? (y/n)"
    if gets.chomp.downcase == "y"
      saved_game = self.to_yaml

      File.open("saved_game.txt","w") do |f|
        f.print saved_game
        return
      end
    end

    puts "Would you like to load? (y/n)"
    if gets.chomp.downcase == "y"
      loaded_game = YAML::load(File.read("saved_game.txt"))
      loaded_game.play
    end

    begin
      puts "Please enter X coordinate and then Y coordinate"
      x = gets.chomp.to_i
      y = gets.chomp.to_i

      raise MinesweeperError unless x <= 8 && x >= 0 && y <= 8 && y >= 0
    rescue MinesweeperError
      puts "Choose a valid number!"
      make_move
    end

      coords = [x,y]

    begin

      puts "REVEAL or FLAG?"
      choice = gets.chomp.downcase

      raise MinesweeperError unless choice == "reveal" || choice == "flag"
    rescue MinesweeperError
      puts "Choose REVEAL or FLAG!"
      make_move
    end

    if choice == "reveal"
      @game.reveal(coords)
    else
      @game.flag(coords)
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

    begin
      puts "What difficulty? (expert, medium, or easy)"
      difficulty = gets.chomp.downcase

      puts "board size?"
      board_size = gets.chomp.to_i
      raise MinesweeperError if board_size <= 0 || board_size > 30
    rescue MinesweeperError
      puts "That board size? Really? Let's be reasonable."
      self.play
    end

    @game = Board.new(board_size, difficulty)
    @game.populate

    begin_time = Time.now

    until won? || lost?
      display
      make_move
    end

    if won?
      puts "You win!"
    end

    if lost?
      puts "You lose :("
    end

    end_time = Time.now

    total_time = end_time - begin_time

    @leaderboard << total_time

    puts "Total Game Time: #{total_time} seconds!"

    puts "Fastest time is #{@leaderboard.sort.first}!"

    puts "Play again? (y/n)"

    if gets.chomp == "y"
      @board = Board.new
      self.play
    end

    nil
  end

end