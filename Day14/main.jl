### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""Day 14: Extended Polymerization
The incredible pressures at this depth are starting to put a strain on your submarine. The submarine has polymerization equipment that would produce suitable materials to reinforce the submarine, and the nearby volcanically-active caves should even have the necessary input elements in sufficient quantities.

The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer template and a list of pair insertion rules (your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.

For example:

```
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
```

The first line is the polymer template - this is the starting point of the process.

The following section defines the pair insertion rules. A rule like AB -> C means that when elements A and B are immediately adjacent, element C should be inserted between them. These insertions all happen simultaneously.

So, starting with the polymer template NNCB, the first step simultaneously considers all three pairs:

The first pair (NN) matches the rule NN -> C, so element C is inserted between the first N and the second N.
The second pair (NC) matches the rule NC -> B, so element B is inserted between the N and the C.
The third pair (CB) matches the rule CB -> H, so element H is inserted between the C and the B.
Note that these pairs overlap: the second element of one pair is the first element of the next pair. Also, because all pairs are considered simultaneously, inserted elements are not considered to be part of a pair until the next step.

After the first step of this process, the polymer becomes NCNBCHB.

Here are the results of a few steps using the above rules:
```
Template:     NNCB
After step 1: NCNBCHB
After step 2: NBCCNBBBCBHCB
After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB
```

This polymer grows quickly. After step 5, it has length 97; After step 10, it has length 3073. After step 10, B occurs 1749 times, C occurs 298 times, H occurs 161 times, and N occurs 865 times; taking the quantity of the most common element (B, 1749) and subtracting the quantity of the least common element (H, 161) produces 1749 - 161 = 1588.

Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin
	println("\nDay 14: Extended Polymerization")

	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	lines = Array{String}(undef, countlines(input_file))
	polymer_pair_list = Vector{String}()
	polymer_morph_dict = Dict{String, Tuple}()
	local polymer
	open(input_file) do f
		current_index = 1
		for l in eachline(f)
			if current_index == 1
				polymer = split(l,"")
				for i in 1:length(polymer)-1
					polymer_pair = polymer[i] * polymer[i+1]
					push!(polymer_pair_list, polymer_pair)
				end
			end

			if occursin("->", l)
				from, middle = split(l, " -> ")
				from_a, from_b = split(from, "")
				polymer_morph_dict[from] = (from_a * middle, middle * from_b)
			end

			current_index += 1
    	end
	end
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin
	function polymarize(polymer_pair_list, polymer_morph_dict)
		new_polymer_pair_list = Vector{String}()

		for polymer_pair in polymer_pair_list
			for next_polymer_pair in polymer_morph_dict[polymer_pair]
				push!(new_polymer_pair_list, next_polymer_pair)
			end
		end
		
		return new_polymer_pair_list
	end

	function count_polymers(new_polymer_pair_list)
		polymer_count_dict = Dict{Char, Int}()
		for (index, pair) in enumerate(new_polymer_pair_list)
			first_polymer = first(pair)
			if !haskey(polymer_count_dict, first_polymer)
				polymer_count_dict[first_polymer] = 0
			end
			polymer_count_dict[first_polymer] += 1

			if index == length(new_polymer_pair_list)
				second_polymer = last(pair)
				if !haskey(polymer_count_dict, second_polymer)
					polymer_count_dict[second_polymer] = 0
				end
				polymer_count_dict[second_polymer] += 1
			end
		end
		return polymer_count_dict
	end

	local new_polymer_pair_list = polymer_pair_list
	for i in 1:10
		new_polymer_pair_list = polymarize(new_polymer_pair_list, polymer_morph_dict)
	end

	local polymer_count_dict = count_polymers(new_polymer_pair_list)
	local min_polymer_count = minimum(values(polymer_count_dict))
	local max_polymer_count = maximum(values(polymer_count_dict))

	println("Part 1: ", max_polymer_count - min_polymer_count)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""
The resulting polymer isn't nearly strong enough to reinforce the submarine. You'll need to run more steps of the pair insertion process; a total of 40 steps should do it.

In the above example, the most common element is B (occurring 2192039569602 times) and the least common element is H (occurring 3849876073 times); subtracting these produces 2188189693529.

Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin
	polymer_pair_dict = Dict{String, Int}()
	last_polymer_pair = polymer_pair_list[length(polymer_pair_list)]
	for i in 1:length(polymer_pair_list)-1
		polymer_pair = polymer_pair_list[i]
		if !haskey(polymer_pair_dict, polymer_pair)
			polymer_pair_dict[polymer_pair] = 0
		end
		polymer_pair_dict[polymer_pair] += 1
	end

	function polymarize2(polymer_pair_dict, last_polymer_pair, polymer_morph_dict)
		new_polymer_pair_dict = Dict{String, Int}()

		for (polymer_pair, count) in polymer_pair_dict
			for next_polymer_pair in polymer_morph_dict[polymer_pair]
				if !haskey(new_polymer_pair_dict, next_polymer_pair)
					new_polymer_pair_dict[next_polymer_pair] = 0
				end
				new_polymer_pair_dict[next_polymer_pair] += count
			end
		end
		
		other_polymer, new_last_polymer_pair = polymer_morph_dict[last_polymer_pair]
		if !haskey(new_polymer_pair_dict, other_polymer)
			new_polymer_pair_dict[other_polymer] = 0
		end
		new_polymer_pair_dict[other_polymer] += 1

		return new_polymer_pair_dict, new_last_polymer_pair
	end

	function count_polymers2(new_polymer_pair_dict, new_last_polymer_pair)
		polymer_count_dict = Dict{Char, Int}()

		for (pair, count) in new_polymer_pair_dict
			first_polymer = first(pair)
			if !haskey(polymer_count_dict, first_polymer)
				polymer_count_dict[first_polymer] = 0
			end
			polymer_count_dict[first_polymer] += count
		end

		second_polymer = last(new_last_polymer_pair)
		if !haskey(polymer_count_dict, second_polymer)
			polymer_count_dict[second_polymer] = 0
		end
		polymer_count_dict[second_polymer] += 1

		return polymer_count_dict
	end

	local new_polymer_pair_dict = polymer_pair_dict
	local new_last_polymer_pair = last_polymer_pair
	for i in 1:40
		new_polymer_pair_dict, new_last_polymer_pair  = polymarize2(new_polymer_pair_dict, new_last_polymer_pair, polymer_morph_dict)
	end

	local polymer_count_dict = count_polymers2(new_polymer_pair_dict, new_last_polymer_pair)
	local min_polymer_count = minimum(values(polymer_count_dict))
	local max_polymer_count = maximum(values(polymer_count_dict))

	println("Part 2: ", max_polymer_count - min_polymer_count, "\n")
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
