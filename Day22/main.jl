### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 22: Reactor Reboot
Operating at these extreme ocean depths has overloaded the submarine's reactor; it needs to be rebooted.

The reactor core is made up of a large 3-dimensional grid made up entirely of cubes, one cube per integer 3-dimensional coordinate (x,y,z). Each cube can be either on or off; at the start of the reboot process, they are all off. (Could it be an old model of a reactor you've seen before?)

To reboot the reactor, you just need to set all of the cubes to either on or off by following a list of reboot steps (your puzzle input). Each step specifies a cuboid (the set of all cubes that have coordinates which fall within ranges for x, y, and z) and whether to turn all of the cubes in that cuboid on or off.

For example, given these reboot steps:
```
on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
off x=9..11,y=9..11,z=9..11
on x=10..10,y=10..10,z=10..10
```

The first step (on x=10..12,y=10..12,z=10..12) turns on a 3x3x3 cuboid consisting of 27 cubes:

```
10,10,10
10,10,11
10,10,12
10,11,10
10,11,11
10,11,12
10,12,10
10,12,11
10,12,12
11,10,10
11,10,11
11,10,12
11,11,10
11,11,11
11,11,12
11,12,10
11,12,11
11,12,12
12,10,10
12,10,11
12,10,12
12,11,10
12,11,11
12,11,12
12,12,10
12,12,11
12,12,12
```

The second step (on x=11..13,y=11..13,z=11..13) turns on a 3x3x3 cuboid that overlaps with the first. As a result, only 19 additional cubes turn on; the rest are already on from the previous step:

```
11,11,13
11,12,13
11,13,11
11,13,12
11,13,13
12,11,13
12,12,13
12,13,11
12,13,12
12,13,13
13,11,11
13,11,12
13,11,13
13,12,11
13,12,12
13,12,13
13,13,11
13,13,12
13,13,13
```

The third step (off x=9..11,y=9..11,z=9..11) turns off a 3x3x3 cuboid that overlaps partially with some cubes that are on, ultimately turning off 8 cubes:

```
10,10,10
10,10,11
10,11,10
10,11,11
11,10,10
11,10,11
11,11,10
11,11,11
```

The final step (on x=10..10,y=10..10,z=10..10) turns on a single cube, 10,10,10. After this last step, 39 cubes are on.

The initialization procedure only uses cubes that have x, y, and z positions of at least -50 and at most 50. For now, ignore cubes outside this region.

Here is a larger example:

```
on x=-20..26,y=-36..17,z=-47..7
on x=-20..33,y=-21..23,z=-26..28
on x=-22..28,y=-29..23,z=-38..16
on x=-46..7,y=-6..46,z=-50..-1
on x=-49..1,y=-3..46,z=-24..28
on x=2..47,y=-22..22,z=-23..27
on x=-27..23,y=-28..26,z=-21..29
on x=-39..5,y=-6..47,z=-3..44
on x=-30..21,y=-8..43,z=-13..34
on x=-22..26,y=-27..20,z=-29..19
off x=-48..-32,y=26..41,z=-47..-37
on x=-12..35,y=6..50,z=-50..-2
off x=-48..-32,y=-32..-16,z=-15..-5
on x=-18..26,y=-33..15,z=-7..46
off x=-40..-22,y=-38..-28,z=23..41
on x=-16..35,y=-41..10,z=-47..6
off x=-32..-23,y=11..30,z=-14..3
on x=-49..-5,y=-3..45,z=-29..18
off x=18..30,y=-20..-8,z=-3..13
on x=-41..9,y=-7..43,z=-33..15
on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
on x=967..23432,y=45373..81175,z=27513..53682
```

The last two steps are fully outside the initialization procedure area; all other steps are fully within it. After executing these steps in the initialization procedure region, 590784 cubes are on.

Execute the reboot steps. **Afterward, considering only cubes in the region x=-50..50,y=-50..50,z=-50..50, how many cubes are on?**

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 22: Reactor Reboot")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	cubes = Array{Tuple}(undef, countlines(input_file))

	open(input_file) do f
		current_index = 1
		for l in eachline(f)
        	space_split = split(l, " ")
			switch = space_split[1]

			comma_split = split(space_split[2], ",")

			x_range_substring = split(replace(comma_split[1], "x=" => ""), "..")
			x_range = parse(Int,x_range_substring[1]), parse(Int, x_range_substring[2])
			if x_range[1] > x_range[2]
				x_range = x_range[2], x_range[1]
			end

			y_range_substring = split(replace(comma_split[2], "y=" => ""), "..")
			y_range = parse(Int,y_range_substring[1]), parse(Int, y_range_substring[2])
			if y_range[1] > y_range[2]
				y_range = y_range[2], y_range[1]
			end

			z_range_substring = split(replace(comma_split[3], "z=" => ""), "..")
			z_range = parse(Int,z_range_substring[1]), parse(Int, z_range_substring[2])
			if z_range[1] > z_range[2]
				z_range = z_range[2], z_range[1]
			end

			cubes[current_index] = switch, x_range, y_range, z_range

			current_index += 1
    	end
	end	
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	function coords_to_string(x, y, z)		
		return string(x) * "," * string(y) * "," * string(z) 
	end

	function turn_on_cubes(cube_map, x_range, y_range, z_range)
		for x in x_range[1]:x_range[2]
			for y in y_range[1]:y_range[2]
				for z in z_range[1]:z_range[2]
					if !haskey(cube_map, coords_to_string(x, y, z))
						cube_map[coords_to_string(x, y, z)] = true
					end
				end
			end
		end
	end

	function turn_off_cubes(cube_map, x_range, y_range, z_range)
		for x in x_range[1]:x_range[2]
			for y in y_range[1]:y_range[2]
				for z in z_range[1]:z_range[2]
					if haskey(cube_map, coords_to_string(x, y, z))
						delete!(cube_map, coords_to_string(x, y, z))
					end
				end
			end
		end
	end

	cube_map = Dict{String,Bool}()
	for i in 1:length(cubes)
		# println(i, "  ", cubes[i])

		x_range = deepcopy(cubes[i][2])
		y_range = deepcopy(cubes[i][3])
		z_range = deepcopy(cubes[i][4])

		if x_range[1] > 50 || y_range[1] > 50 || z_range[1] > 50
			continue
		end

		if x_range[2] < -50 || y_range[2] < -50 || z_range[2] < -50
			continue
		end

		if x_range[2] > 50 
			x_range = (x_range[1], 50)
		elseif y_range[2] > 50 
			y_range = (y_range[1], 50)
		elseif z_range[2] > 50
			z_range = (z_range[1], 50)
		end

		if x_range[1] < -50 
			x_range = (-50, x_range[2])
		elseif y_range[2] > 50 
			y_range = (-50, y_range[2])
		elseif z_range[2] > 50
			z_range = (-50, z_range[2])
		end

		if cubes[i][1] == "on"
			turn_on_cubes(cube_map, x_range, y_range, z_range)
		elseif cubes[i][1] == "off"
			turn_off_cubes(cube_map, x_range, y_range, z_range)
		end
	end

	println("Part 1: ", length(cube_map))
	(length(cube_map))
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""
Now that the initialization procedure is complete, you can reboot the reactor.

Starting with all cubes off, run all of the reboot steps for all cubes in the reactor.

Consider the following reboot steps:

```
on x=-5..47,y=-31..22,z=-19..33
on x=-44..5,y=-27..21,z=-14..35
on x=-49..-1,y=-11..42,z=-10..38
on x=-20..34,y=-40..6,z=-44..1
off x=26..39,y=40..50,z=-2..11
on x=-41..5,y=-41..6,z=-36..8
off x=-43..-33,y=-45..-28,z=7..25
on x=-33..15,y=-32..19,z=-34..11
off x=35..47,y=-46..-34,z=-11..5
on x=-14..36,y=-6..44,z=-16..29
on x=-57795..-6158,y=29564..72030,z=20435..90618
on x=36731..105352,y=-21140..28532,z=16094..90401
on x=30999..107136,y=-53464..15513,z=8553..71215
on x=13528..83982,y=-99403..-27377,z=-24141..23996
on x=-72682..-12347,y=18159..111354,z=7391..80950
on x=-1060..80757,y=-65301..-20884,z=-103788..-16709
on x=-83015..-9461,y=-72160..-8347,z=-81239..-26856
on x=-52752..22273,y=-49450..9096,z=54442..119054
on x=-29982..40483,y=-108474..-28371,z=-24328..38471
on x=-4958..62750,y=40422..118853,z=-7672..65583
on x=55694..108686,y=-43367..46958,z=-26781..48729
on x=-98497..-18186,y=-63569..3412,z=1232..88485
on x=-726..56291,y=-62629..13224,z=18033..85226
on x=-110886..-34664,y=-81338..-8658,z=8914..63723
on x=-55829..24974,y=-16897..54165,z=-121762..-28058
on x=-65152..-11147,y=22489..91432,z=-58782..1780
on x=-120100..-32970,y=-46592..27473,z=-11695..61039
on x=-18631..37533,y=-124565..-50804,z=-35667..28308
on x=-57817..18248,y=49321..117703,z=5745..55881
on x=14781..98692,y=-1341..70827,z=15753..70151
on x=-34419..55919,y=-19626..40991,z=39015..114138
on x=-60785..11593,y=-56135..2999,z=-95368..-26915
on x=-32178..58085,y=17647..101866,z=-91405..-8878
on x=-53655..12091,y=50097..105568,z=-75335..-4862
on x=-111166..-40997,y=-71714..2688,z=5609..50954
on x=-16602..70118,y=-98693..-44401,z=5197..76897
on x=16383..101554,y=4615..83635,z=-44907..18747
off x=-95822..-15171,y=-19987..48940,z=10804..104439
on x=-89813..-14614,y=16069..88491,z=-3297..45228
on x=41075..99376,y=-20427..49978,z=-52012..13762
on x=-21330..50085,y=-17944..62733,z=-112280..-30197
on x=-16478..35915,y=36008..118594,z=-7885..47086
off x=-98156..-27851,y=-49952..43171,z=-99005..-8456
off x=2032..69770,y=-71013..4824,z=7471..94418
on x=43670..120875,y=-42068..12382,z=-24787..38892
off x=37514..111226,y=-45862..25743,z=-16714..54663
off x=25699..97951,y=-30668..59918,z=-15349..69697
off x=-44271..17935,y=-9516..60759,z=49131..112598
on x=-61695..-5813,y=40978..94975,z=8655..80240
off x=-101086..-9439,y=-7088..67543,z=33935..83858
off x=18020..114017,y=-48931..32606,z=21474..89843
off x=-77139..10506,y=-89994..-18797,z=-80..59318
off x=8476..79288,y=-75520..11602,z=-96624..-24783
on x=-47488..-1262,y=24338..100707,z=16292..72967
off x=-84341..13987,y=2429..92914,z=-90671..-1318
off x=-37810..49457,y=-71013..-7894,z=-105357..-13188
off x=-27365..46395,y=31009..98017,z=15428..76570
off x=-70369..-16548,y=22648..78696,z=-1892..86821
on x=-53470..21291,y=-120233..-33476,z=-44150..38147
off x=-93533..-4276,y=-16170..68771,z=-104985..-24507
```

After running the above reboot steps, 2758514936282235 cubes are on. (Just for fun, 474140 of those are also in the initialization procedure region.)

Starting again with all cubes off, execute all reboot steps. Afterward, considering all cubes, how many cubes are on?
"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin	
	function is_intersected(cuboid1, cuboid2)
		if !(cuboid1[1][1] <= cuboid2[1][2] && cuboid1[1][2] >= cuboid2[1][1])
			return false
		end

		if !(cuboid1[2][1] <= cuboid2[2][2] && cuboid1[2][2] >= cuboid2[2][1])
			return false
		end

		if !(cuboid1[3][1] <= cuboid2[3][2] && cuboid1[3][2] >= cuboid2[3][1])
			return false
		end

    	return true
	end

	function get_intersected_cuboid(cuboid1, cuboid2)
		min_x = max(cuboid1[1][1], cuboid2[1][1])
		max_x = min(cuboid1[1][2], cuboid2[1][2])
	
		min_y = max(cuboid1[2][1], cuboid2[2][1])
		max_y = min(cuboid1[2][2], cuboid2[2][2])
	
		min_z = max(cuboid1[3][1], cuboid2[3][1])
		max_z = min(cuboid1[3][2], cuboid2[3][2])
	
		sign = -cuboid2[4]
	
		return ((min_x, max_x), (min_y, max_y), (min_z, max_z), sign)
	end

	function calculate_cuboid_volume(cuboid)
		x_d = cuboid[1][2] - cuboid[1][1] + 1
		y_d = cuboid[2][2] - cuboid[2][1] + 1
		z_d = cuboid[3][2] - cuboid[3][1] + 1
		sign = cuboid[4]
    	return x_d * y_d * z_d * sign
	end

	cube_map = Dict{String,Bool}()
	cuboids = Tuple[]
	for i in 1:length(cubes)
		# println(i, "  ", cubes[i])

		x_range = deepcopy(cubes[i][2])
		y_range = deepcopy(cubes[i][3])
		z_range = deepcopy(cubes[i][4])

		if cubes[i][1] == "on"
			sign = 1
		elseif cubes[i][1] == "off"
			sign = -1
		end

		current_cuboid = (x_range, y_range, z_range, sign)

		intersections = Tuple[]
		for saved_cuboid in cuboids
			if is_intersected(current_cuboid, saved_cuboid)
				intersected_cuboid = get_intersected_cuboid(current_cuboid, saved_cuboid)
				push!(intersections, intersected_cuboid)
			end 
		end

		for intersected_cuboid in intersections
			push!(cuboids, intersected_cuboid)
		end

		if cubes[i][1] == "on"
			push!(cuboids, current_cuboid)
		end
	end
		
	local count = 0
	for cuboid in cuboids
		count += calculate_cuboid_volume(cuboid)
	end

	println("Part 2: ", count, "\n")
	(count)
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
