### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 4: Giant Squid 

You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.

Maybe it wants to play bingo?

Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:

```
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
```

After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):

```
22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
```

After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:

```
22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
```

Finally, 24 is drawn:

```
22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
```

At this point, the third board wins because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: 14 21 17 24 4).

The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 4")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	boards = Vector{Dict{Int, Vector{Int8}}}(undef, 10)
	boards_as_sets = Vector{Dict{Int, Set}}(undef, 0)
	bingo_nums = nothing
	
	open(input_file) do f
		current_index = 1
		board_index = 0
		ticket_index = 1
		for l in eachline(f)	
			global bingo_nums
			if current_index == 1
				bingo_nums = split(l, ",")
				bingo_nums = parse.(Int8, bingo_nums)
			elseif l == ""
				ticket_index = 1
				board_index += 1			
			else
				if ticket_index == 1
					if board_index > length(boards)
						resize!(boards, length(boards) * 2)
					end
					boards[board_index] = Dict()
				end
				
				row = split(strip(replace(l, "  " => " ")), " ")	
				row = parse.(Int8, row)
				boards[board_index][ticket_index] = row
				ticket_index += 1
			end
			
			current_index += 1
    	end

		resize!(boards, board_index)
		resize!(boards_as_sets, board_index)

		# Calculate columns
		for board in boards	
			row_size = length(board)
			for i in 1:row_size
				current_col = Vector{Int8}(undef, row_size)
				for j in 1:row_size	
					current_col[j] = board[j][i]
				end		
				board[row_size + i] = current_col
			end
		end

		for (index, board) in enumerate(boards)
			current_board_set = Dict{Int, Set}()
			for (index, ticket) in board
				current_board_set[index] = Set(deepcopy(ticket))
			end			
			boards_as_sets[index] = current_board_set
		end	
	end	
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	local winning_board = 0
	local winning_ticket = 0
	local winning_num = 0
	local boards_as_sets_copy = deepcopy(boards_as_sets)
	
	for num in bingo_nums
		for (board_index, board) in enumerate(boards_as_sets_copy)
			for ticket_num in 1:length(board)
				
				delete!(boards_as_sets_copy[board_index][ticket_num], num)

				if length(boards_as_sets_copy[board_index][ticket_num]) == 0
					winning_board = board_index
					winning_ticket = ticket_num
					winning_num = num
					break
				end
			end	
			if winning_num > 0
				break
			end
		end
		if winning_num > 0
			break
		end
	end

	local total = 0
	for ticket_num in 1:length(boards_as_sets[1][1])
		for undeleted_num in boards_as_sets_copy[winning_board][ticket_num]
			total += undeleted_num
		end
	end

	local final_score = winning_num * total
	println("Part 1: ", final_score)
	(winning_num, total, final_score, winning_board, winning_ticket)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""

On the other hand, it might be wise to try a different strategy: let the giant squid win.

You aren't sure how many bingo boards a giant squid could play at once, so rather than waste time counting its arms, the safe thing to do is to figure out which board will win last and choose that one. That way, no matter which boards it picks, it will win for sure.

In the above example, the second board is the last to win, which happens after 13 is eventually called and its middle column is completely marked. If you were to keep playing until this point, the second board would have a sum of unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.

Figure out which board will win last. Once it wins, what would its final score be?

"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	local winning_boards = Vector{Int}(undef, length(boards_as_sets))
	local boards_as_sets_copy = deepcopy(boards_as_sets)

	local board_count = 0

	local winning_board = 0
	local winning_ticket = 0
	local winning_num = 0
	
	for num in bingo_nums
		for (board_index, board) in enumerate(boards_as_sets_copy)
			skip = false
			for i in 1:board_count
				if board_index == winning_boards[i]
					skip = true
					break
				end
			end

			if skip
				continue
			end

			
			for ticket_num in 1:length(board)
				delete!(boards_as_sets_copy[board_index][ticket_num], num)

				if length(boards_as_sets_copy[board_index][ticket_num]) == 0
					winning_board = board_index
					winning_ticket = ticket_num
					winning_num = num
					
					board_count += 1
					winning_boards[board_count] = winning_board
						
					break
				end
			end	
			
		end
	end
		
	local total = 0
	for ticket_num in 1:length(boards_as_sets[1][1])
		for undeleted_num in boards_as_sets_copy[winning_board][ticket_num]
			total += undeleted_num
		end
	end

	local final_score = winning_num * total
	println("Part 2: ", final_score, "\n")
	(winning_num, total, final_score, winning_board, winning_ticket)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╠═cdeddb50-52d2-11ec-38a8-c5d56295952f
# ╠═1b840d5a-8b64-4b45-8537-849674f9c548
# ╠═dfe034c8-820c-498b-a227-777515c4cee5
# ╠═3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
# ╠═3c9f2b64-b3af-4fa3-b668-0b57aabfad73
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
