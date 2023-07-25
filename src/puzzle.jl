struct Piece
    id::Int
    # edges should be sorted top, right, bottom, left
    edges::Vector{Int8}
end

function Base.copy(p::Piece)
    Piece(p.id, copy(p.edges))
end

struct Board
    pieces::Vector{Union{Nothing,Piece}}
    rotations::Vector{UInt8}
end

function Board()
    Board(fill(nothing, 9), fill(1, 9))
end

function Base.copy(b::Board)
    Board([copy(p) for p in b.pieces], copy(b.rotations))
end