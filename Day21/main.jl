### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 21: Dirac Dice
There's not much to do as you slowly descend to the bottom of the ocean. The submarine computer challenges you to a nice game of Dirac Dice.

This game consists of a single die, two pawns, and a game board with a circular track containing ten spaces marked 1 through 10 clockwise. Each player's starting space is chosen randomly (your puzzle input). Player 1 goes first.

Players take turns moving. On each player's turn, the player rolls the die three times and adds up the results. Then, the player moves their pawn that many times forward around the track (that is, moving clockwise on spaces in order of increasing value, wrapping back around to 1 after 10). So, if a player is on space 7 and they roll 2, 2, and 1, they would move forward 5 times, to spaces 8, 9, 10, 1, and finally stopping on 2.

After each player moves, they increase their score by the value of the space their pawn stopped on. Players' scores start at 0. So, if the first player starts on space 7 and rolls a total of 5, they would stop on space 2 and add 2 to their score (for a total score of 2). The game immediately ends as a win for any player whose score reaches at least 1000.

Since the first game is a practice game, the submarine opens a compartment labeled deterministic dice and a 100-sided die falls out. This die always rolls 1 first, then 2, then 3, and so on up to 100, after which it starts over at 1 again. Play using this die.

For example, given these starting positions:
```
Player 1 starting position: 4
Player 2 starting position: 8
```

This is how the game would go:
```
Player 1 rolls 1+2+3 and moves to space 10 for a total score of 10.
Player 2 rolls 4+5+6 and moves to space 3 for a total score of 3.
Player 1 rolls 7+8+9 and moves to space 4 for a total score of 14.
Player 2 rolls 10+11+12 and moves to space 6 for a total score of 9.
Player 1 rolls 13+14+15 and moves to space 6 for a total score of 20.
Player 2 rolls 16+17+18 and moves to space 7 for a total score of 16.
Player 1 rolls 19+20+21 and moves to space 6 for a total score of 26.
Player 2 rolls 22+23+24 and moves to space 6 for a total score of 22.
...after many turns...

Player 2 rolls 82+83+84 and moves to space 6 for a total score of 742.
Player 1 rolls 85+86+87 and moves to space 4 for a total score of 990.
Player 2 rolls 88+89+90 and moves to space 3 for a total score of 745.
Player 1 rolls 91+92+93 and moves to space 10 for a final score, 1000.
```

Since player 1 has at least 1000 points, player 1 wins and the game ends. At this point, the losing player had 745 points and the die had been rolled a total of 993 times; 745 * 993 = 739785.

Play a practice game using the deterministic 100-sided die. The moment either player wins, what do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 21: Dirac Dice")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	player1_postition = 0
	player2_postition = 0

	open(input_file) do f
		for l in eachline(f)
			if occursin("Player 1", l)
				global player1_postition
				player1_postition = parse(Int, split(l, ": ")[2])
			else
				global player2_postition
				player2_postition = parse(Int, split(l, ": ")[2])
			end
    	end
	end	
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	local round = 0
	local dice = 0

	local player1_score = 0
	local player2_score = 0

	local dice_roll_count = 0
	while true
		round += 1

		for p in 1:2
			global player1_postition
			global player2_postition

			dice_roll_count += 3

			dice1 = dice + 1
			if dice1 > 100
				dice1 %= 100 
			end

			dice2 = dice + 2
			if dice2 > 100
				dice2 %= 100
			end

			dice3 = dice + 3
			if dice3 > 100
				dice3 %= 100
			end

			if p == 1
				current_round_score = player1_postition + dice1 + dice2 + dice3
				if current_round_score > 10
					current_round_score %= 10
				end
				if current_round_score == 0
					current_round_score = 10
				end
				player1_postition = current_round_score
				player1_score += current_round_score
			else 
				current_round_score = player2_postition + dice1 + dice2 + dice3
				if current_round_score > 10
					current_round_score %= 10
				end
				if current_round_score == 0
					current_round_score = 10				
				end
				player2_postition = current_round_score
				player2_score += current_round_score
			end

			dice = dice3

			if player1_score >= 1000 || player2_score >= 1000
				break
			end
		end

		if player1_score >= 1000 || player2_score >= 1000
			break
		end
	end

	println("Part 1: ", (player1_score >= 1000 ? player2_score : player1_score) * dice_roll_count)
	((player1_score >= 1000 ? player2_score : player1_score) * dice_roll_count)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""
Now that you're warmed up, it's time to play the real game.

A second compartment opens, this time labeled Dirac dice. Out of it falls a single three-sided die.

As you experiment with the die, you feel a little strange. An informational brochure in the compartment explains that this is a quantum die: when you roll it, the universe splits into multiple copies, one copy for each possible outcome of the die. In this case, rolling the die always splits the universe into three copies: one where the outcome of the roll was 1, one where it was 2, and one where it was 3.

The game is played the same as before, although to prevent things from getting too far out of hand, the game now ends when either player's score reaches at least 21.

Using the same starting positions as in the example above, player 1 wins in 444356092776315 universes, while player 2 merely wins in 341960390180808 universes.

Using your given starting positions, determine every possible outcome. **Find the player that wins in more universes; in how many universes does that player win?**
"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	function pocket_universe(player, dice_sum, stats)	
		player1_score = stats[1]
		player1_postition = stats[2]
		player2_score = stats[3]
		player2_postition = stats[4]
		universe_count = stats[5]

		if player == 1
			current_round_score = player1_postition + dice_sum
			if current_round_score > 10
				current_round_score %= 10
			end
			if current_round_score == 0
				current_round_score = 10
			end
			player1_postition = current_round_score
			player1_score += current_round_score
		else 
			current_round_score = player2_postition + dice_sum
			if current_round_score > 10
				current_round_score %= 10
			end
			if current_round_score == 0
				current_round_score = 10				
			end
			player2_postition = current_round_score
			player2_score += current_round_score
		end
				
		if player1_score >= 21 
			outcome = 1
		elseif player2_score >= 21 
			outcome = 2
		else 
			outcome = 0
		end		

		return outcome, (player1_score, player1_postition, player2_score, player2_postition, universe_count)
	end


	function big_bang(player1_postition, player2_postition)
		player1_score = 0
		player2_score = 0

		player1_wins = Int128(0)
		player2_wins = Int128(0)

		universe_count = 1

		current_stats_store = Tuple[(player1_score, player1_postition, player2_score, player2_postition, universe_count)]

		dice_sum_count_map = Dict{Int, Int}()

		for x in 1:3
			for y in 1:3
				for z in 1:3
					dice_sum = x + y + z
					if !haskey(dice_sum_count_map, dice_sum)
						dice_sum_count_map[dice_sum] = 0
					end
					dice_sum_count_map[dice_sum] += 1
				end
			end
		end	

		universe_count = Int128(1)
		while true
			for p in 1:2	
				new_current_stats_store = Tuple[]
				for current_stats in current_stats_store
					for (dice_sum, occurance) in dice_sum_count_map
						outcome, stats = pocket_universe(p, dice_sum, current_stats)

						universe_count = stats[5] * occurance
						if outcome == 1	
							player1_wins += universe_count
						elseif outcome == 2
							player2_wins += universe_count
						else
							push!(new_current_stats_store, (stats[1], stats[2], stats[3], stats[4], universe_count))
						end							
					end
				end
				current_stats_store = new_current_stats_store

				if length(current_stats_store) == 0					
					return (player1_wins, player2_wins)
				end
			end	
				
		end
	end

	win_counts = big_bang(player1_postition, player2_postition)
	println("Part 2: ", max(win_counts[1], win_counts[2]), "\n")
	(max(win_counts[1], win_counts[2]))
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
