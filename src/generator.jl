function generate_puzzle()
    # TODO +1s and -1s need to be at least close to balanced
    pieces = [Piece(i, rand((-1,1), 4)) for i in 1:9]
    value2edges = Dict{Int, SLinkedList{Tuple{Int,Int}}}()
    for (ip,p) in enumerate(pieces)
        for (ie,e) in enumerate(p.edges)
            if !haskey(value2edges, e)
                value2edges[e] = SLinkedList{Tuple{Int,Int}}()
            end
            push!(value2edges[e], (ip,ie))
        end
    end
    println("$(length(value2edges[1])), $(length(value2edges[-1]))")
    # loop until there is only one solution left
    num_configs_tried = 0
    while true
        solutions = solve(pieces, 2)
        # TODO what happens when there are 0 solutions left
        length(solutions) == 0 && return false
        length(solutions) == 1 && return pieces
        # If there are still multiple solutions left do one of two things
        # swap 2 neighboring edges (same piece) or increase the absolute value of a random edge
        idx2change, edge2change = rand(1:9), rand(1:4)
        if rand() > 0.5
            # change one random edge to a higher (absolute) value
            v2c = pieces[idx2change].edges[edge2change]
            pieces[idx2change].edges[edge2change] += sign(v2c)
            # change a second edge (of opposite sign) to match the new edge
            ll2 = value2edges[-v2c]
            ll2_idx = rand(1:length(ll2))
            idx2change2, edge2change2 = ll2[ll2_idx]
            @assert pieces[idx2change2].edges[edge2change2] == -v2c
            pieces[idx2change2].edges[edge2change2] -= sign(v2c)
            # update the value2edges dictionary
            deleteat!(value2edges[v2c], findfirst(==((idx2change,edge2change)), value2edges[v2c]))
            deleteat!(value2edges[-v2c], findfirst(==((idx2change2,edge2change2)), value2edges[-v2c]))
            if !haskey(value2edges, v2c + sign(v2c))
                value2edges[v2c + sign(v2c)] = SLinkedList{Tuple{Int,Int}}()
                value2edges[-v2c - sign(v2c)] = SLinkedList{Tuple{Int,Int}}()
            end
            push!(value2edges[v2c + sign(v2c)], (idx2change,edge2change))
            push!(value2edges[-v2c - sign(v2c)], (idx2change2,edge2change2))
        else
            # swap two neighboring edges
            v1 = pieces[idx2change].edges[edge2change]
            v2 = pieces[idx2change].edges[mod1(edge2change+1,4)]
            pieces[idx2change].edges[edge2change] = pieces[idx2change].edges[mod1(edge2change+1, 4)]
            pieces[idx2change].edges[mod1(idx2change+1,4)] = v1
            # update the value2edges dictionary
            deleteat!(value2edges[v1], findfirst(==((idx2change,edge2change)), value2edges[v1]))
            deleteat!(value2edges[v2], findfirst(==((idx2change,mod1(edge2change+1,4))), value2edges[v2]))
            push!(value2edges[v1], (idx2change,mod1(edge2change+1,4)))
            push!(value2edges[v2], (idx2change,edge2change))
        end
        num_configs_tried += 1
        println("tried $num_configs_tried configurations")
    end
end
