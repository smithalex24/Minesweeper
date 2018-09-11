require_relative "cell"

class Board
	attr_accessor :cells_array, :valid_coords, :converted_cells
	def initialize
		@column_count = 10
		@row_count = 10
		@cells_array = create_cells_array
		@valid_coords = create_valid_coords
		@converted_cells = convert_cells_array_to_values	
	end

	def display
		 add_padding
		 display_header
		 display_cells
		 add_padding
	end
	
	def display_header
		puts "    " + (0...@column_count).to_a.join(" ")
		puts "    - - - - - - - - - -"
	end

	def display_cells 
		converted_cells.each_with_index do | row, index | 
			puts index.to_s + " | " + row.map(&:display_value).join(" ")
		end
	end

	def add_padding
		puts "\n\n" 
	end

	def create_cells_array
		cells_array = [] 
		(0...@column_count).each do | column |
			row_array = []
			(0...@row_count).each do | row | 
				row_array << Cell.new(row, column)
			end
			cells_array << row_array
		end
		cells_array 	
	end

	def convert_cells_array_to_values
		cells_value_array = []
		cells_array.each_with_index do | row, row_index |
			row_of_cells_array = []
			row.each_with_index do | cell, col_index |
				cell.value = if cell.bomb 
								 9
							 else
								 value = 0
								 surrounding_coords_for(row_index, col_index).each do | coords |
									value += 1 if cells_array.dig(coords.first, coords.last)&.bomb && valid_coords.include?([coords.first, coords.last])					
								 end
								 value 
							 end
							 row_of_cells_array << cell 

			end
			cells_value_array << row_of_cells_array
		end
		cells_value_array
	end

	def surrounding_coords_for(row, column)
		surrounding_coords = []
		surrounding_coords << [row - 1, column]
		surrounding_coords << [row - 1, column + 1]
		surrounding_coords << [row, column + 1]
		surrounding_coords << [row + 1, column + 1]
		surrounding_coords << [row + 1, column - 1]
		surrounding_coords << [row + 1, column]
		surrounding_coords << [row, column - 1]
		surrounding_coords << [row - 1, column - 1]
		surrounding_coords
	end

	def create_valid_coords
		coords = []
		(0...@row_count).each do | row |
			(0...@column_count).each do | column |
				coords << [row, column]
			end
		end
		coords
	end

	def reveal_cells 
		converted_cells.flatten.each { | cell | cell.visible = true }
	end

	def reveal_cells_touching_zero(coords)
		converted_cells[coords.first.to_i][coords.last.to_i].visible = true
		surrounding_coords_for(coords.first.to_i, coords.last.to_i).each do | coords |
			cell = converted_cells[coords.first.to_i][coords.last.to_i]
			if valid_coords.include?(coords) && !cell.bomb
				if cell.value.zero? && cell.visible = false
					reveal_cells_touching_zero(coords)
				end
				cell.visible = true			
			end
		end
	end

	def all_non_bomb_cells_visible?
		converted_cells.flatten.each do | cell | 
			return false unless cell.visible || cell.bomb	
		end
		true
	end	
end
	
	
puts Board.new.display