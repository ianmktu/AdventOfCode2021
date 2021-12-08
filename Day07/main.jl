### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 7: The Treachery of Whales 

A giant whale has decided your submarine is its next meal, and it's much faster than you are. There's nowhere to run!

Suddenly, a swarm of crabs (each in its own tiny submarine - it's too deep for them otherwise) zooms in to rescue you! They seem to be preparing to blast a hole in the ocean floor; sensors indicate a massive underground cave system just beyond where they're aiming!

The crab submarines all need to be aligned before they'll have enough power to blast a large enough hole for your submarine to get through. However, it doesn't look like they'll be aligned before the whale catches you! Maybe you can help?

There's one major catch - crab submarines can only move horizontally.

You quickly make a list of the horizontal position of each crab (your puzzle input). Crab submarines have limited fuel, so you need to find a way to make all of their horizontal positions match while requiring them to spend as little fuel as possible.

For example, consider the following horizontal positions:

16,1,2,0,4,2,7,1,2,14
This means there's a crab with horizontal position 16, a crab with horizontal position 1, and so on.

Each change of 1 step in horizontal position of a single crab costs 1 fuel. You could choose any horizontal position to align them all on, but the one that costs the least fuel is horizontal position 2:

```
Move from 16 to 2: 14 fuel
Move from 1 to 2: 1 fuel
Move from 2 to 2: 0 fuel
Move from 0 to 2: 2 fuel
Move from 4 to 2: 2 fuel
Move from 2 to 2: 0 fuel
Move from 7 to 2: 5 fuel
Move from 1 to 2: 1 fuel
Move from 2 to 2: 0 fuel
Move from 14 to 2: 12 fuel
```

This costs a total of 37 fuel. This is the cheapest possible outcome; more expensive outcomes include aligning at position 1 (41 fuel), position 3 (39 fuel), or position 10 (71 fuel).

Determine the horizontal position that the crabs can align to using the least fuel possible. **How much fuel must they spend to align to that position?**

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 7: The Treachery of Whales")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	positions = Array{Int}(undef, 0)

	open(input_file) do f
		for l in eachline(f)
        	split_nums = split(l,",")
			resize!(positions, length(split_nums))
			for (index, num) in enumerate(split_nums)
				positions[index] = parse(Int, num)
			end
    	end
	end	
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	local min_fuel_used = -1
	for target in 0:maximum(positions)
		current_fuel = 0
		for (index, position) in enumerate(positions)
			current_fuel += abs(position - target)
		end
		if target == 0
			min_fuel_used = current_fuel
		elseif current_fuel < min_fuel_used
			min_fuel_used = current_fuel
		end
	end

	println("Part 1: ", min_fuel_used)
	(min_fuel_used)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""

The crabs don't seem interested in your proposed solution. Perhaps you misunderstand crab engineering?

As it turns out, crab submarine engines don't burn fuel at a constant rate. Instead, each change of 1 step in horizontal position costs 1 more unit of fuel than the last: the first step costs 1, the second step costs 2, the third step costs 3, and so on.

As each crab moves, moving further becomes more expensive. This changes the best horizontal position to align them all on; in the example above, this becomes 5:

```
Move from 16 to 5: 66 fuel
Move from 1 to 5: 10 fuel
Move from 2 to 5: 6 fuel
Move from 0 to 5: 15 fuel
Move from 4 to 5: 1 fuel
Move from 2 to 5: 6 fuel
Move from 7 to 5: 3 fuel
Move from 1 to 5: 10 fuel
Move from 2 to 5: 6 fuel
Move from 14 to 5: 45 fuel
```

This costs a total of 168 fuel. This is the new cheapest possible outcome; the old alignment position (2) now costs 206 fuel instead.

Determine the horizontal position that the crabs can align to using the least fuel possible so they can make you an escape route! **How much fuel must they spend to align to that position?**

"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	local min_fuel_used = -1
	for target in 0:maximum(positions)
		current_fuel = 0
		for (index, position) in enumerate(positions)
			n = abs(position - target)
			current_fuel += Int((n * (n + 1)) / 2)
		end
		if target == 0
			min_fuel_used = current_fuel
		elseif current_fuel < min_fuel_used
			min_fuel_used = current_fuel
		end
	end

	println("Part 2: ", min_fuel_used, "\n")
	(min_fuel_used)
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
