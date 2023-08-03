module NinePiecePuzzle

using Combinatorics

include("puzzle.jl")
include("utils.jl")
include("solver.jl")
include("generator.jl")

export Piece, Board
export read_puzzle_file, write_puzzle_file, solve
export generate_puzzles

end # module NinePiecePuzzle
