function all_pieces(n_colors, min_unique_colors_per_piece)
    unique_pieces = Set{Vector{Int8}}()
    for i in 0:n_colors^4-1
        edge_string = string(i, base=n_colors, pad=4)
        @assert length(edge_string) == 4 "i=$i edge_string=$edge_string"
        length(Set(edge_string)) < min_unique_colors_per_piece && continue
        correct_edge_string = edge_string
        min_number = parse(Int, edge_string)
        for _ in 1:3
            edge_string = edge_string[2:end] * edge_string[1]
            edge_string_value = parse(Int, edge_string)
            if edge_string_value < min_number
                min_number = edge_string_value
                correct_edge_string = edge_string 
            end
        end
        push!(unique_pieces, [parse(Int8, e) for e in correct_edge_string])
    end
    collect(unique_pieces)
end

function generate_puzzles(num_colors)
    unique_pieces = all_pieces(num_colors, 4)
    puzzle_gen_file = open("puzzles/gen_$num_colors", "w")
    for edges in combinations(unique_pieces, 9)
        pieces = [Piece(i, edges[i]) for i in 1:9]
        solutions = solve(pieces; stop_after_n=2, same_edge=true)
        if length(solutions) == 1
            write(puzzle_gen_file, "$(join(join.(edges)))\n")
        end
    end
    close(puzzle_gen_file)
end
