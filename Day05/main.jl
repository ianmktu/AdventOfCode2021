### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 5: Hydrothermal Venture

You come across a field of hydrothermal vents on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.

They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:

```
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
```

Each line of vents is given as a line segment in the format `x1,y1 -> x2,y2` where `x1,y1` are the coordinates of one end the line segment and `x2,y2` are the coordinates of the other end. These line segments include the points at both ends. In other words:

- An entry like `1,1 -> 1,3` covers points `1,1`, `1,2`, and `1,3`.
- An entry like `9,7 -> 7,7` covers points `9,7`, `8,7`, and `7,7`.

For now, only consider horizontal and vertical lines: lines where either `x1 = x2` or `y1 = y2`.

So, the horizontal and vertical lines from the above list would produce the following diagram:

```
.......1..
..1....1..
..1....1..
.......1..
.112111211
..........
..........
..........
..........
222111....
```

In this diagram, the top left corner is `0,0` and the bottom right corner is `9,9`. Each position is shown as the number of lines which cover that point or . if no line covers that point. The top-left pair of 1s, for example, comes from `2,2 -> 2,1`; the very bottom row is formed by the overlapping lines `0,9 -> 5,9` and `0,9 -> 2,9`.

To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.

Consider only horizontal and vertical lines. At how many points do at least two lines overlap?

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 5: Hydrothermal Venture")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	coords = Array{Int}(undef, countlines(input_file), 4)

	open(input_file) do f
		current_index = 1
		for l in eachline(f)
			coord_pairs = split(l, " -> ")
			coord_index = 1
			for coord in coord_pairs
				for num in split(coord, ",")
					coords[current_index, coord_index] = parse(Int, num)
					coord_index += 1
				end
			end
			current_index += 1
    	end
	end	
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	local vent_counter = 1
	local vent_map = Dict()
	for (index, coord) in enumerate(eachrow(coords))
		if coord[1] == coord[3]
			y1 = 0
			y2 = 0			
			if coord[2] < coord[4]
				y1 = coord[2]
				y2 = coord[4]
			else
				y1 = coord[4]
				y2 = coord[2]
			end

			for y in y1:y2
				key = string(coord[1]) * ',' * string(y)

				if !haskey(vent_map, key)
					vent_map[key] = 0
				end

				vent_map[key] += 1
			end
	
			vent_counter += 1
		elseif coord[2] == coord[4]
			x1 = 0
			x2 = 0			

			if coord[1] < coord[3]
				x1 = coord[1]
				x2 = coord[3]
			else
				x1 = coord[3]
				x2 = coord[1]
			end

			for x in x1:x2
				key = string(x) * ',' * string(coord[2])

				if !haskey(vent_map, key)
					vent_map[key] = 0
				end
				
				vent_map[key] += 1
			end

			vent_counter += 1
		end
	end

	local multiple_vent_counter = 0
	for value in values(vent_map)
		if value > 1
			multiple_vent_counter += 1
		end
	end

	println("Part 1: ", multiple_vent_counter)
	(multiple_vent_counter)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""

Unfortunately, considering only horizontal and vertical lines doesn't give you the full picture; you need to also consider diagonal lines.

Because of the limits of the hydrothermal vent mapping system, the lines in your list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees. In other words:

An entry like `1,1 -> 3,3` covers points `1,1`, `2,2`, and `3,3`.
An entry like `9,7 -> 7,9` covers points `9,7`, `8,8`, and `7,9`.
Considering all lines from the above example would now produce the following diagram:

```
1.1....11.
.111...2..
..2.1.111.
...1.2.2..
.112313211
...1.2....
..1...1...
.1.....1..
1.......1.
222111....
```

You still need to determine the number of points where at least two lines overlap. In the above example, this is still anywhere in the diagram with a 2 or larger - now a total of 12 points.

Consider all of the lines. At how many points do at least two lines overlap?
"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	local vent_counter = 1
	local vent_map = Dict()
	for (index, coord) in enumerate(eachrow(coords))
		if coord[1] == coord[3]
			y1 = 0
			y2 = 0	

			if coord[2] < coord[4]
				y1 = coord[2]
				y2 = coord[4]
			else
				y1 = coord[4]
				y2 = coord[2]
			end

			for y in y1:y2
				key = string(coord[1]) * ',' * string(y)

				if !haskey(vent_map, key)
					vent_map[key] = 0
				end

				vent_map[key] += 1
			end
	
			vent_counter += 1
		elseif coord[2] == coord[4]
			x1 = 0
			x2 = 0	

			if coord[1] < coord[3]
				x1 = coord[1]
				x2 = coord[3]
			else
				x1 = coord[3]
				x2 = coord[1]
			end

			for x in x1:x2
				key = string(x) * ',' * string(coord[2])

				if !haskey(vent_map, key)
					vent_map[key] = 0
				end
				
				vent_map[key] += 1
			end

			vent_counter += 1		
		elseif abs(coord[1] - coord[3]) == abs(coord[2] - coord[4])
			x1 = 0
			x2 = 0
			y1 = 0
			y2 = 0

			if coord[1] < coord[3]
				x1 = coord[1]
				y1 = coord[2]

				x2 = coord[3]
				y2 = coord[4]
			else
				x1 = coord[3]
				y1 = coord[4]

				y2 = coord[2]
				x2 = coord[1]
			end	

			y_increment = 1
			if y1 > y2
				y_increment = -1
			end

			y = y1
			for x in x1:x2
				key = string(x) * ',' * string(y)

				if !haskey(vent_map, key)
					vent_map[key] = 0
				end
				
				vent_map[key] += 1
				y += y_increment
			end

			vent_counter += 1
		end
	end

	local multiple_vent_counter = 0
	for value in values(vent_map)
		if value > 1
			multiple_vent_counter += 1
		end
	end

	println("Part 2: ", multiple_vent_counter, "\n")
	(multiple_vent_counter)
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
