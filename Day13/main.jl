### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 13: Transparent Origami
You reach another volcanically active part of the cave. It would be nice if you could do some kind of thermal imaging so you could tell ahead of time which caves are too hot to safely enter.

Fortunately, the submarine seems to be equipped with a thermal camera! When you activate it, you are greeted with:

Congratulations on your purchase! To activate this infrared thermal imaging
camera system, please enter the code found on page 1 of the manual.
Apparently, the Elves have never used this feature. To your surprise, you manage to find the manual; as you go to open it, page 1 falls out. It's a large sheet of transparent paper! The transparent paper is marked with random dots and includes instructions on how to fold it up (your puzzle input). For example:

```
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
```

The first section is a list of dots on the transparent paper. 0,0 represents the top-left coordinate. The first value, x, increases to the right. The second value, y, increases downward. So, the coordinate 3,0 is to the right of 0,0, and the coordinate 0,7 is below 0,0. The coordinates in this example form the following pattern, where # is a dot on the paper and . is an empty, unmarked position:

```
...#..#..#.
....#......
...........
#..........
...#....#.#
...........
...........
...........
...........
...........
.#....#.##.
....#......
......#...#
#..........
#.#........
```

Then, there is a list of fold instructions. Each instruction indicates a line on the transparent paper and wants you to fold the paper up (for horizontal y=... lines) or left (for vertical x=... lines). In this example, the first fold instruction is fold along y=7, which designates the line formed by all of the positions where y is 7 (marked here with -):

```
...#..#..#.
....#......
...........
#..........
...#....#.#
...........
...........
-----------
...........
...........
.#....#.##.
....#......
......#...#
#..........
#.#........
```

Because this is a horizontal line, fold the bottom half up. Some of the dots might end up overlapping after the fold is complete, but dots will never appear exactly on a fold line. The result of doing this fold looks like this:

```
#.##..#..#.
#...#......
......#...#
#...#......
.#.#..#.###
...........
...........
```

Now, only 17 dots are visible.

Notice, for example, the two dots in the bottom left corner before the transparent paper is folded; after the fold is complete, those dots appear in the top left corner (at 0,0 and 0,1). Because the paper is transparent, the dot just below them in the result (at 0,3) remains visible, as it can be seen through the transparent paper.

Also notice that some dots can end up overlapping; in this case, the dots merge together and become a single dot.

The second fold instruction is fold along x=5, which indicates this line:

```
#.##.|#..#.
#...#|.....
.....|#...#
#...#|.....
.#.#.|#.###
.....|.....
.....|.....
```

Because this is a vertical line, fold left:

```
#####
#...#
#...#
#...#
#####
.....
.....
```

The instructions made a square!

The transparent paper is pretty big, so for now, focus on just completing the first fold. After the first fold in the example above, 17 dots are visible - dots that end up overlapping after the fold is completed count as a single dot.

**How many dots are visible after completing just the first fold instruction on your transparent paper?**

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin
	println("\nDay 13: Transparent Origami")

	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	grid_set = Set{Tuple}()
	rules = Array{Tuple}(undef, countlines(input_file))

	open(input_file) do f
		current_index = 1
		for l in eachline(f)
			if occursin(",", l)
				x, y = split(l, ",")
				push!(grid_set, (parse(Int64,x), parse(Int64,y)))
			end

			if occursin("fold along", l)
				_, fold = split(l, "fold along ")
				plane, value = split(fold, "=")
				rules[current_index] = (first(plane), parse(Int64,value))
				current_index += 1
			end
    	end
		resize!(rules, current_index - 1)
	end
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin
	function make_new_grid(rule, old_grid)
		new_grid = Set{Tuple}()
		if rule[1] == 'x'
			reflect_value = rule[2]
			for coord in old_grid
				if coord[1] < reflect_value
					push!(new_grid, coord)
				elseif coord[1] > reflect_value
					push!(new_grid, (2 * reflect_value - coord[1], coord[2]))
				end
			end
		elseif rule[1] == 'y'
			reflect_value = rule[2]
			for coord in old_grid
				if coord[2] < reflect_value
					push!(new_grid, coord)
				elseif coord[2] > reflect_value
					push!(new_grid, (coord[1], 2 * reflect_value - coord[2]))
				end
			end
		end
	
		return new_grid
	end

	current_grid = make_new_grid(rules[1], grid_set)
	println("Part 1: ", length(current_grid))
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""
Finish folding the transparent paper according to the instructions. The manual says the code is always eight capital letters.

**What code do you use to activate the infrared thermal imaging camera system?**
"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin
	local current_grid = grid_set

	for rule in rules
		current_grid = make_new_grid(rule, current_grid)
	end
	
	final_grid = deepcopy(current_grid)
	local max_x = 0
	local max_y = 0
	for coords in current_grid
		if coords[1] > max_x
			max_x = coords[1]
		end

		if coords[2] > max_y
			max_y = coords[2]
		end
	end

	println("Part 2: ",)
	for y in 0:max_y
		if y != 0
			println()
		end
		for x in 0:max_x
			if (x, y) in final_grid
				print("X")
			else
				print(" ")
			end
		end
	end
	println()
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
