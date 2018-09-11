class Cell
	attr_accessor :row, :col, :visible, :bomb, :value, :display_value
	def initialize(row, column)
		@row = row
		@col = column
		@visible = false
		@bomb = rand(100) > 80
		@value = nil 
	end 

	def display_value 
		return "#" unless visible
		return "*" if bomb
		value.zero? ? ' ' : value 
	end
end
