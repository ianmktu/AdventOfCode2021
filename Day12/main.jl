### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 12: Passage Pathing
With your submarine's subterranean subsystems subsisting suboptimally, the only way you're getting out of this cave anytime soon is by finding a path yourself. Not just a path - the only way to know if you've found the best path is to find all of them.

Fortunately, the sensors are still mostly working, and so you build a rough map of the remaining caves (your puzzle input). For example:

```
start-A
start-b
A-c
A-b
b-d
A-end
b-end
```

This is a list of how all of the caves are connected. You start in the cave named start, and your destination is the cave named end. An entry like b-d means that cave b is connected to cave d - that is, you can move between them.

So, the above cave system looks roughly like this:

```
    start
    /   \
c--A-----b--d
    \   /
     end
```

Your goal is to find the number of distinct paths that start at start, end at end, and don't visit small caves more than once. There are two types of caves: big caves (written in uppercase, like A) and small caves (written in lowercase, like b). It would be a waste of time to visit any small cave more than once, but big caves are large enough that it might be worth visiting them multiple times. So, all paths you find should visit small caves at most once, and can visit big caves any number of times.

Given these rules, there are 10 paths through this example cave system:

```
start,A,b,A,c,A,end
start,A,b,A,end
start,A,b,end
start,A,c,A,b,A,end
start,A,c,A,b,end
start,A,c,A,end
start,A,end
start,b,A,c,A,end
start,b,A,end
start,b,end
```

(Each line in the above list corresponds to a single path; the caves visited by that path are listed in the order they are visited and separated by commas.)

Note that in this cave system, cave d is never visited by any path: to do so, cave b would need to be visited twice (once on the way to cave d and a second time when returning from cave d), and since cave b is small, this is not allowed.

Here is a slightly larger example:

```
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
```

The 19 paths through it are as follows:

```
start,HN,dc,HN,end
start,HN,dc,HN,kj,HN,end
start,HN,dc,end
start,HN,dc,kj,HN,end
start,HN,end
start,HN,kj,HN,dc,HN,end
start,HN,kj,HN,dc,end
start,HN,kj,HN,end
start,HN,kj,dc,HN,end
start,HN,kj,dc,end
start,dc,HN,end
start,dc,HN,kj,HN,end
start,dc,end
start,dc,kj,HN,end
start,kj,HN,dc,HN,end
start,kj,HN,dc,end
start,kj,HN,end
start,kj,dc,HN,end
start,kj,dc,end
```

Finally, this even larger example has 226 paths through it:

```
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
```

How many paths through this cave system are there that visit small caves at most once?
"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 12: Passage Pathing")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	lines = Array{String}(undef, countlines(input_file))

	node_map = Dict{String, Set}()

	open(input_file) do f
		current_index = 1
		for l in eachline(f)
			a, b = split(l, "-")

			if !haskey(node_map, a)
				node_map[a] = Set()
			end
			push!(node_map[a], b)

			if !haskey(node_map, b)
				node_map[b] = Set()
			end
			push!(node_map[b], a)

			current_index += 1
    	end
	end


	node_visit_count_map = Dict{String, Int}()
	for key in keys(node_map)
		if occursin(r"^[A-Z,\s]+$", key)
			node_visit_count_map[key] = -1
		else
			node_visit_count_map[key] = 1
		end
	end

end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin
	function node_count(node, node_map, node_visit_count_map, travel_string)
		node_set = node_map[node]

		node_visit_count_map[node] -= 1
		if node_visit_count_map[node] == 0
			delete!(node_visit_count_map, node)
			delete!(node_map, node)
		end

		local count = 0
		for n in node_set
			if !haskey(node_map, n)
				continue
			end

			if n == "end"
				count += 1
				# println(travel_string * "-" * n)
			else
				count += node_count(n, deepcopy(node_map), deepcopy(node_visit_count_map), travel_string * "-" * n)
			end
		end
		return count
	end

	start_node = "start"
	local total_count = node_count(start_node, deepcopy(node_map), deepcopy(node_visit_count_map), start_node)
	
	println("Part 1: ", total_count)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""
After reviewing the available paths, you realize you might have time to visit a single small cave twice. Specifically, big caves can be visited any number of times, a single small cave can be visited at most twice, and the remaining small caves can be visited at most once. However, the caves named start and end can only be visited exactly once each: once you leave the start cave, you may not return to it, and once you reach the end cave, the path must end immediately.

Now, the 36 possible paths through the first example above are:

```
start,A,b,A,b,A,c,A,end
start,A,b,A,b,A,end
start,A,b,A,b,end
start,A,b,A,c,A,b,A,end
start,A,b,A,c,A,b,end
start,A,b,A,c,A,c,A,end
start,A,b,A,c,A,end
start,A,b,A,end
start,A,b,d,b,A,c,A,end
start,A,b,d,b,A,end
start,A,b,d,b,end
start,A,b,end
start,A,c,A,b,A,b,A,end
start,A,c,A,b,A,b,end
start,A,c,A,b,A,c,A,end
start,A,c,A,b,A,end
start,A,c,A,b,d,b,A,end
start,A,c,A,b,d,b,end
start,A,c,A,b,end
start,A,c,A,c,A,b,A,end
start,A,c,A,c,A,b,end
start,A,c,A,c,A,end
start,A,c,A,end
start,A,end
start,b,A,b,A,c,A,end
start,b,A,b,A,end
start,b,A,b,end
start,b,A,c,A,b,A,end
start,b,A,c,A,b,end
start,b,A,c,A,c,A,end
start,b,A,c,A,end
start,b,A,end
start,b,d,b,A,c,A,end
start,b,d,b,A,end
start,b,d,b,end
start,b,end
```

The slightly larger example above now has 103 paths through it, and the even larger example now has 3509 paths through it.

Given these new rules, how many paths through this cave system are there?

"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin
	node_visit_count_map = Dict{String, Int}()
	for key in keys(node_map)
		if occursin(r"^[A-Z,\s]+$", key)
			node_visit_count_map[key] = -1
		elseif key == "start"
			node_visit_count_map[key] = 1
		elseif key == "end"
			node_visit_count_map[key] = -1
		else
			node_visit_count_map[key] = 2
		end
	end

	function node_count(node, node_map, node_visit_count_map, travel_string, twice)
		if !haskey(node_visit_count_map, node)
			return 0
		end

		node_set = node_map[node]

		node_visit_count_map[node] -= 1
		if node_visit_count_map[node] == 0
			delete!(node_visit_count_map, node)
			delete!(node_map, node)

			if node != "start" && twice
				for (key, value) in node_visit_count_map
					if value == 2
						node_visit_count_map[key] = 1
					elseif value == 1
						delete!(node_visit_count_map, key)
						delete!(node_map, node)
					end
				end
				twice = false
			end
		end

		local count = 0
		for n in node_set
			if !haskey(node_map, n)
				continue
			end

			if n == "end"
				count += 1
				# println(travel_string * "-" * n)
			else
				count += node_count(n, deepcopy(node_map), deepcopy(node_visit_count_map), travel_string * "-" * n, twice)
			end
		end
		return count
	end

	start_node = "start"
	twice = true
	local total_count = node_count(start_node, deepcopy(node_map), deepcopy(node_visit_count_map), start_node, twice)

	println("Part 2: ", total_count, "\n")
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
