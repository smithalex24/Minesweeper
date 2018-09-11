require_relative "board"
require "byebug"

class Game
	attr_accessor :board 
	
	def initialize 
		@board = Board.new
	end

	def start_game 
		board.display
		take_turn
	end

	def take_turn 
		coords = request_coords
		return invalid_coords_error_message unless valid_coords?(coords)
		cell = board.converted_cells[coords.first.to_i][coords.last.to_i]
		if cell.bomb
			game_over
		else 
			if cell.visible == false && cell.value.zero?
				board.reveal_cells_touching_zero(coords)
			end
			cell.visible = true
			if winner?
				game_won
			else
				board.display
				take_turn
			end
		end
	end

	def request_coords 
		puts " Which one do you want to reveal? ex. row,col "
		gets.chomp.strip.split(",")
	end

	def invalid_coords_error_message 
		puts "Invalid coords. Try again."
		gets.chomp.strip.split(",")
	end

	def valid_coords?(coords)
		board.valid_coords.include?([coords.first.to_i, coords.last.to_i])
	end

	def game_over 
		board.reveal_cells
		board.display
		play_again?("Game over! Play again?")
	end

	def winner? 
		board.all_non_bomb_cells_visible?
	end

	def game_won 
		board.reveal_cells
		board.display
		play_again?("You won! Play again?")
	end

	def play_again?(message) 
		puts message
		if gets.chomp == "Yes"
			self.board = Board.new
			start_game
		else
			puts "Thanks for playing!"
		end
	end
end

Game.new.start_game