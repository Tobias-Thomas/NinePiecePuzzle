const SOLVE_ORDER = [5,6,9,8,7,4,1,2,3]

function solve(pieces::Vector{Piece})
    board = Board()
    piece_avail = fill(true, 9)
    solutions = Board[]
    solve_rec(board, pieces, piece_avail, 1, solutions)
    solutions
end

function solve_rec(board, pieces, piece_avail, current_pos, solutions)
    board_pos = SOLVE_ORDER[current_pos]
    for next_piece in 1:9
        !piece_avail[next_piece] && continue
        piece_avail[next_piece] = false
        for rot in 0:3
            if check_if_piece_fits(board, pieces[next_piece], board_pos, rot)
                board.pieces[board_pos] = pieces[next_piece]
                board.rotations[board_pos] = rot
                if current_pos == 9
                    push!(solutions, copy(board))
                else
                    solve_rec(board, pieces, piece_avail, current_pos+1, solutions)
                end
            end
        end
        piece_avail[next_piece] = true
    end
end

const BORDERS2CHECK = [
    [(4,1)],
    [(1,2), (5,1)],
    [(2,2), (6,1)],
    [(5,4), (7,1)],
    [],
    [(5,2)],
    [(8,4)],
    [(9,4), (5,3)],
    [(6,3)]
]

function check_if_piece_fits(board, piece, piece_position, piece_rotation)
    if piece_position == 5
        return piece_rotation == 0
    end
    check_borders = BORDERS2CHECK[piece_position]
    for (other_position, other_edge) in check_borders
        piece_edge = mod1(other_edge + 2, 4)
        other_piece_edges = board.pieces[other_position].edges
        other_edge_value = other_piece_edges[mod1(other_edge-board.rotations[other_position], 4)]
        piece_edge_value = piece.edges[mod1(piece_edge-piece_rotation, 4)]
        piece_edge_value + other_edge_value != 0 && return false
    end
    return true
end