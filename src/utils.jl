function read_puzzle_file(path)
    piece_strings = readlines(path)
    pieces = Piece[]
    for (i,s) in enumerate(piece_strings)
        edges = [parse(Int8, s[e:e+1]) for e in 1:3:10]
        push!(pieces, Piece(i, edges))
    end
    return pieces
end

function write_puzzle_file(pieces, filepath)
    io = open(filepath, "w")
    whitespace = " "
    empty = ""
    for p in pieces
        for e in p.edges
            write(io, "$(e > 0 ? whitespace : empty)$e ")
        end
        write(io, "\n")
    end
    close(io)
end

function print_board_simple(board::Board)
    for i in 1:9
        piece, rot = board.pieces[i], board.rotations[i]
        if piece isa Piece
            print("$(piece.id)/$rot ")
        else
            print("-/- ")
        end
        if i % 3 == 0
            print("\n")
        end
    end
end

# I know this is type piracy and bad style, but the package seems to have stopped development
# still should make a pull request for it..
function Base.getindex(lst::SLinkedList, idx::Int)
    !(0 < idx <= length(lst)) && throw(BoundsError("index $idx"))
    return lst[positiontoindex(idx, lst)]
end

function Base.getindex(lst::LinkedList, idx::Int)
    !(0 < idx <= length(lst)) && throw(BoundsError("index $idx"))
    return lst[positiontoindex(idx, lst)]
end
