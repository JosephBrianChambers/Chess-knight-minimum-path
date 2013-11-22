require 'debugger'
class KnightPathFinder
  def initialize(start_position)
    @starting_square = father_square(start_position)
    @move_tree = build_move_tree
  end

  def father_square(start_position)
    Square.new(start_position)
  end

  def build_move_tree
    #keep track of visited postions using local variable
  end

  def self.new_move_positons(pos)
    candidate_moves = [
      [pos[0]  +1, pos[1] + 2],
      [pos[0]  +1, pos[1] - 2],
      [pos[0]  -1, pos[1] + 2],
      [pos[0]  -1, pos[1] - 2],
      [pos[0] + 2, pos[1] + 1],
      [pos[0] + 2, pos[1] - 1],
      [pos[0]  -2, pos[1] + 1],
      [pos[0]  -2, pos[1] - 1]
    ]

    available_moves = candidate_moves.select do |x,y|
      x.between?(0,7) && y.between?(0,7)
    end
    available_moves
  end

  def find_target(target_pos)
    visited_squares = []
    squares_to_check = [@starting_square]

    until squares_to_check.empty?
      #reject already seen squares
      check = visited_squares.any? do |square|
        square.location == squares_to_check[0].location
      end


      squares_to_check.shift if check

      current_square = squares_to_check.shift
      visited_squares << current_square
      return current_square if current_square.location == target_pos

      current_square.make_children
      squares_to_check += current_square.children
    end
    puts "Target not found. from find_path method"
  end


  def find_path(target_pos)
    target_square = find_target(target_pos)

    path = []

    while target_square.parent != nil
      path << target_square.location
      target_square = target_square.parent
    end
    path << @starting_square.location
    path.reverse
  end

end


class Square
  attr_accessor :parent, :location

  def initialize(square_location)
    @location = square_location
    @parent = nil
    @children = []
  end
  def children
    @children
  end
  def make_children
    possible_move_pos = KnightPathFinder.new_move_positons(@location)

    new_squares  = possible_move_pos.map do |location|
      make_square(location)
    end

    @children += new_squares
  end

  def make_square(location)
    child = Square.new(location)
    child.parent = self
    child
  end
end
 
 
start_coord  = ARGV[0].scan(/(\d),(\d)/)
target_coord = ARGV[1].scan(/(\d),(\d)/)
start_pos = [start_coord[0][0].to_i, start_coord[0][1].to_i]
target_pos = [target_coord[0][0].to_i, target_coord[0][1].to_i]

 finder_instance = KnightPathFinder.new(start_pos)
 p finder_instance.find_path(target_pos)

