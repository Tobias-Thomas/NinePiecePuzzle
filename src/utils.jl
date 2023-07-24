function read_puzzle_file(path)
    piece_strings = readlines(path)
    pieces = Piece[]
    for (i,s) in enumerate(piece_strings)
        edges = [parse(Int8, s[e:e+1]) for e in 1:3:10]
        push!(pieces, Piece(i, edges))
    end
    return pieces
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