### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 20: Trench Map
With the scanners fully deployed, you turn their attention to mapping the floor of the ocean trench.

When you get back the image from the scanners, it seems to just be random noise. Perhaps you can combine an image enhancement algorithm and the input image (your puzzle input) to clean it up a little.

For example:

```
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
#..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###
.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.
.#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....
.#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..
...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....
..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
```

The first section is the image enhancement algorithm. It is normally given on a single line, but it has been wrapped to multiple lines in this example for legibility. The second section is the input image, a two-dimensional grid of light pixels (#) and dark pixels (.).

The image enhancement algorithm describes how to enhance an image by simultaneously converting all pixels in the input image into an output image. Each pixel of the output image is determined by looking at a 3x3 square of pixels centered on the corresponding input image pixel. So, to determine the value of the pixel at (5,10) in the output image, nine pixels from the input image need to be considered: (4,9), (4,10), (4,11), (5,9), (5,10), (5,11), (6,9), (6,10), and (6,11). These nine input pixels are combined into a single binary number that is used as an index in the image enhancement algorithm string.

For example, to determine the output pixel that corresponds to the very middle pixel of the input image, the nine pixels marked by [...] would need to be considered:

```
# . . # .
#[. . .].
#[# . .]#
.[. # .].
. . # # #
```

Starting from the top-left and reading across each row, these pixels are ..., then #.., then .#.; combining these forms ...#...#.. By turning dark pixels (.) into 0 and light pixels (#) into 1, the binary number 000100010 can be formed, which is 34 in decimal.

The image enhancement algorithm string is exactly 512 characters long, enough to match every possible 9-bit binary number. The first few characters of the string (numbered starting from zero) are as follows:

```
0         10        20        30  34    40        50        60        70
|         |         |         |   |     |         |         |         |
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
```

In the middle of this first group of characters, the character at index 34 can be found: #. So, the output pixel in the center of the output image should be #, a light pixel.

This process can then be repeated to calculate every pixel of the output image.

Through advances in imaging technology, the images being operated on here are infinite in size. Every pixel of the infinite output image needs to be calculated exactly based on the relevant pixels of the input image. The small input image you have is only a small region of the actual infinite input image; the rest of the input image consists of dark pixels (.). For the purposes of the example, to save on space, only a portion of the infinite-sized input and output images will be shown.

The starting input image, therefore, looks something like this, with more dark pixels (.) extending forever in every direction not shown here:

```
...............
...............
...............
...............
...............
.....#..#......
.....#.........
.....##..#.....
.......#.......
.......###.....
...............
...............
...............
...............
...............
```

By applying the image enhancement algorithm to every pixel simultaneously, the following output image can be obtained:

```
...............
...............
...............
...............
.....##.##.....
....#..#.#.....
....##.#..#....
....####..#....
.....#..##.....
......##..#....
.......#.#.....
...............
...............
...............
...............
```

Through further advances in imaging technology, the above output image can also be used as an input image! This allows it to be enhanced a second time:
```
...............
...............
...............
..........#....
....#..#.#.....
...#.#...###...
...#...##.#....
...#.....#.#...
....#.#####....
.....#.#####...
......##.##....
.......###.....
...............
...............
...............
```

Truly incredible - now the small details are really starting to come through. After enhancing the original input image twice, 35 pixels are lit.

Start with the original input image and apply the image enhancement algorithm twice, being careful to account for the infinite size of the images. **How many pixels are lit in the resulting image?**
"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 20: Trench Map")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")


	algorithm_map = Dict{Int, Char}()
	initial_map = Dict{Tuple, Char}()

	open(input_file) do f
		current_line = 1
		y = 1
		for l in eachline(f)
			if current_line == 1
				for (index, spot) in enumerate(split(l, ""))
					algorithm_map[index-1] = spot[1]
				end
				current_line += 1
				continue
			end

			if current_line == 2
				current_line += 1
				continue
			end

			for (x, spot) in enumerate(split(l, ""))
				if length(spot) == 1
					initial_map[(y,x)] = spot[1]
				end
			end

			y += 1
    	end
	end	

	# for (key,val) in initial_map 
	# 	println(key, " ", val)
	# end

end



# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	function get_xy_limits(input_map)
		min_x = Inf
		max_x = -Inf

		min_y = Inf
		max_y = -Inf

		for (y,x) in keys(input_map)
			if x < min_x
				min_x = x
			end

			if x > max_x
				max_x = x
			end

			if y < min_y
				min_y = y
			end

			if y > max_y
				max_y = y
			end
		end

		return Dict("min_x" => min_x, "max_x" => max_x, "min_y" => min_y, "max_y" => max_y)
	end
	
	function binary_string_to_int(input_string)
		return parse(Int, input_string, base=2)
	end

	function get_new_pixel(input_map, x, y, boundary_value, algorithm_map)
		binary_str = ""

		if boundary_value == '.'
			binary_boundary_value = "0"
		else
			binary_boundary_value = "1"
		end

		coords = [
			(y-1,x-1), (y-1,x), (y-1,x+1),
			(y,x-1), (y,x), (y,x+1),
			(y+1,x-1), (y+1,x), (y+1,x+1)
		]


		for coord in coords
			# if x==0 && y==0
			# 	println(coord)
			# 	println(haskey(input_map, coord) )
			# 	println(boundary_value)
			# 	println(binary_boundary_value)
			# end
			
			if haskey(input_map, coord) 
				if input_map[coord] == '.'
					binary_str *= "0"
				elseif input_map[coord] == '#'
					binary_str *= "1"
				end
			else
				binary_str *= binary_boundary_value
			end
		end

		position = binary_string_to_int(binary_str)

		# if x==0 && y==0
		# 	println("Hello")
		# 	println(binary_str)
		# 	println(position)
		# 	println(algorithm_map[position])
		# end
		# println(binary_str)
		# println(position)
		# println(algorithm_map[position])

		return algorithm_map[position]
	end

	function get_pixel_count(input_map)
		pixel_count = 0
		for pixel in values(input_map)
			if pixel == '#'
				pixel_count += 1
			end
		end
		return pixel_count
	end
	
	function run_algorithm(input_map, iterations)
		local current_map = deepcopy(input_map)

		for round in 1:iterations
			new_map = Dict{Tuple, Char}()

			if round % 2 == 0
				boundary_value = '#'
			else
				boundary_value = '.'
			end

			limits = get_xy_limits(current_map)

			for y in limits["min_y"]-1:limits["max_y"]+1
				for x in limits["min_x"]-1:limits["max_x"]+1
					new_map[(y, x)] = get_new_pixel(current_map, x, y, boundary_value, algorithm_map)
				end
			end

			current_map = new_map
		end

		return get_pixel_count(current_map)
	end

	pixel_count = run_algorithm(initial_map, 2)
	println("Part 1: ", pixel_count)
	(pixel_count)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""
You still can't quite make out the details in the image. Maybe you just didn't enhance it enough.

If you enhance the starting input image in the above example a total of 50 times, 3351 pixels are lit in the final output image.

Start again with the original input image and apply the image enhancement algorithm 50 times. **How many pixels are lit in the resulting image?**
"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	pixel_count = run_algorithm(initial_map, 50)
	println("Part 2: ", pixel_count, "\n")
	(pixel_count)
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
