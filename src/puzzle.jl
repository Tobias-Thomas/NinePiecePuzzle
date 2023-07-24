struct Piece
    id::Int
    edges::Vector{Int8}
end

struct Board
    pieces::Vector{Union{Nothing,Piece}}
    rotations::Vector{UInt8}
end

function Board()
    Board([nothing for _ in 1:9], [1 for _ in 1:9])
end