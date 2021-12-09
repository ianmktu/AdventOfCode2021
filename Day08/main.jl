### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 8: Seven Segment Search

You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it. Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.

As your submarine slowly makes its way through the cave system, you notice that the four-digit seven-segment displays in your submarine are malfunctioning; they must have been damaged during the escape. You'll be in a lot of trouble without them, so you'd better figure out what's wrong.

Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:

```
  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg
```
 
So, to render a 1, only segments c and f would be turned on; the rest would be off. To render a 7, only segments a, c, and f would be turned on.

The problem is that the signals which control the segments have been mixed up on each display. The submarine is still trying to display numbers by producing output on signal wires a through g, but those wires are connected to segments randomly. Worse, the wire/segment connections are mixed up separately for each four-digit display! (All of the digits within a display use the same connections, though.)

So, you might know that only signal wires b and g are turned on, but that doesn't mean segments b and g are turned on: the only digit that uses two segments is 1, so it must mean segments c and f are meant to be on. With just that information, you still can't tell which wire (b/g) goes to which segment (c/f). For that, you'll need to collect more information.

For each display, you watch the changing signals for a while, make a note of all ten unique signal patterns you see, and then write down a single four digit output value (your puzzle input). Using the signal patterns, you should be able to work out which pattern corresponds to which digit.

For example, here is what you might see in a single entry in your notes:

```
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf
```

(The entry is wrapped here to two lines so it fits; in your notes, it will all be on a single line.)

Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are). The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current wire/segment connections. Because 7 is the only digit that uses three segments, dab in the above example means that to render a 7, signal lines d, a, and b are on. Because 4 is the only digit that uses four segments, eafb means that to render a 4, signal lines e, a, f, and b are on.

Using this information, you should be able to work out which combination of signal wires corresponds to each of the ten digits. Then, you can decode the four digit output value. Unfortunately, in the above example, all of the digits in the output value (cdfeb fcadb cdfeb cdbaf) use five segments and are more difficult to deduce.

For now, focus on the easy digits. Consider this larger example:

```
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
fgae cfgab fg bagce
```

Because the digits 1, 4, 7, and 8 each use a unique number of segments, you should be able to tell which combinations of signals correspond to those digits. Counting only digits in the output values (the part after | on each line), in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).

**In the output values, how many times do digits `1`, `4`, `7`, or `8` appear?**

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 8: Seven Segment Search")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	inputs = Array{Vector{String}}(undef, countlines(input_file))
	outputs = Array{Vector{String}}(undef, countlines(input_file))

	open(input_file) do f
		current_index = 1
		for l in eachline(f)
			current_string_arr = split(l, "|")

			input_str_arr = split(strip(current_string_arr[1])," ")
			input_str_vector = Vector{String}(undef, length(input_str_arr))
			for (index, str) in enumerate(input_str_arr)
				input_str_vector[index] = str
			end
			inputs[current_index] = input_str_vector

			output_str_arr = split(strip(current_string_arr[2])," ")
			output_str_vector = Vector{String}(undef, length(output_str_arr))
			for (index, str) in enumerate(output_str_arr)
				output_str_vector[index] = str
			end
        	outputs[current_index] = output_str_vector

			current_index += 1
    	end
	end	
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	local counter = 0
	for (index, output) in enumerate(outputs)
		
		for (str_index, str) in enumerate(output)
			if length(str) in [2, 3, 4, 7]
				counter += 1
			end
		end
	end

	println("Part 1: ", counter)
	(counter)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""

Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

```
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf
```

After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:

```
 dddd
e    a
e    a
 ffff
g    b
g    b
 cccc
```

So, the unique signal patterns would correspond to the following digits:

```
acedgfb: 8
cdfbe: 5
gcdfa: 2
fbcad: 3
dab: 7
cefabd: 9
cdfgeb: 6
eafb: 4
cagedb: 0
ab: 1
```

Then, the four digits of the output value can be decoded:
```
cdfeb: 5
fcadb: 3
cdfeb: 5
cdbaf: 3
```

Therefore, the output value for this entry is 5353.

Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:
```
fdgacbe cefdb cefbgd gcbe: 8394
fcgedb cgb dgebacf gc: 9781
cg cg fdcagb cbg: 1197
efabcd cedba gadfec cb: 9361
gecf egdcabf bgf bfgea: 4873
gebdcfa ecba ca fadegcb: 8418
cefg dcbef fcge gbcadfe: 4548
ed bcgafe cdgba cbgef: 1625
gbdfcae bgc cg cgb: 8717
fgae cfgab fg bagce: 4315
```

Adding all of the output values in this larger example produces 61229.

For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?

"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin	
	local sum = 0
	for i in 1:length(inputs)
		char_map = Dict{Char, Dict}()
		num_to_str_map = Dict{Int8, String}()
		num_to_str_set_map = Dict{Int8, Set}()
		for str in inputs[i]
			if length(str) == 2
				num_to_str_map[1] = str
				num_to_str_set_map[1] = Set()
				for c in str
					push!(num_to_str_set_map[1], c)
				end
			elseif length(str) == 4
				num_to_str_map[4] = str
				num_to_str_set_map[4] = Set()
				for c in str
					push!(num_to_str_set_map[4], c)
				end
			elseif length(str) == 3
				num_to_str_map[7] = str
				num_to_str_set_map[7] = Set()
				for c in str
					push!(num_to_str_set_map[7], c)
				end
			elseif length(str) == 7
				num_to_str_map[8] = str
				num_to_str_set_map[8] = Set()
				for c in str
					push!(num_to_str_set_map[8], c)
				end
			end
		end

		set1 = Set()
		for c in num_to_str_map[7]
			push!(set1, c)
		end

		set2 = Set()
		for c in num_to_str_map[1]
			push!(set2, c)
		end

		char_map['a'] = Dict{Char, Bool}()
		char_map['a'][collect(setdiff(set1, set2))[1]] = true

		char_map['c'] = Dict{Char, Bool}()
		char_map['c'][collect(intersect(set1, set2))[1]] = true
		char_map['c'][collect(intersect(set1, set2))[2]] = true

		char_map['f'] = Dict{Char, Bool}()
		char_map['f'][collect(intersect(set1, set2))[1]] = true
		char_map['f'][collect(intersect(set1, set2))[2]] = true

		set1 = Set()
		for c in num_to_str_map[4]
			push!(set1, c)
		end

		set2 = Set()
		for c in num_to_str_map[1]
			push!(set2, c)
		end

		values_b_d = collect(setdiff(set1, set2))

		char_map['b'] = Dict{Char, Bool}()
		char_map['b'][values_b_d[1]] = true
		char_map['b'][values_b_d[2]] = true

		char_map['d'] = Dict{Char, Bool}()
		char_map['d'][values_b_d[1]] = true
		char_map['d'][values_b_d[2]] = true

		count_dict = Dict{Char, Int}()
		for str in inputs[i]
			if length(str) == 5
				for c in str
					if !haskey(count_dict, c)
						count_dict[c] = 0
					end
					count_dict[c] += 1
				end
			end
		end

		for (key,val) in count_dict
			if val == 1				
				if haskey(char_map['b'], key)
					char_map['b'] = Dict{Char, Bool}([key => true])
					delete!(char_map['d'], key)
				else
					char_map['e'] = Dict{Char, Bool}([key => true])
				end
			end
		end

		count_dict = Dict{Char, Int}()
		for str in inputs[i]
			if length(str) == 6
				for c in str
					if !haskey(count_dict, c)
						count_dict[c] = 0
					end
					count_dict[c] += 1
				end
			end
		end

		for (key,val) in count_dict
			if val == 2		
				skip = false				
				for d in values(char_map)
					if length(d) == 1 && haskey(d, key)
						skip = true
					end
				end
				if skip
					continue
				end
				
				char_map['c'] = Dict{Char, Bool}([key => true])
				delete!(char_map['f'], key)					
				
			end
		end


		true_char_map = Dict{Char, Char}()
		full_set = Set(['a', 'b', 'c', 'd', 'e', 'f', 'g'])
		for (char, val) in char_map
			for key in keys(val)
				true_char_map[char] = key
				delete!(full_set, key)
			end
		end
		true_char_map['g'] = collect(full_set)[1]

		num_to_str_set_map[2] = Set()
		for c in ['a', 'c', 'd', 'e', 'g']
			push!(num_to_str_set_map[2], true_char_map[c])
		end
		
		num_to_str_set_map[3] = Set()
		for c in ['a', 'c', 'd', 'f', 'g']
			push!(num_to_str_set_map[3], true_char_map[c])
		end

		num_to_str_set_map[5] = Set()
		for c in ['a', 'b', 'd', 'f', 'g']
			push!(num_to_str_set_map[5], true_char_map[c])
		end

		num_to_str_set_map[0] = Set()
		for c in ['a', 'b', 'c', 'e', 'f', 'g']
			push!(num_to_str_set_map[0], true_char_map[c])
		end
		
		num_to_str_set_map[6] = Set()
		for c in ['a', 'b', 'd', 'e', 'f', 'g']
			push!(num_to_str_set_map[6], true_char_map[c])
		end

		num_to_str_set_map[9] = Set()
		for c in ['a', 'b', 'c', 'd', 'f', 'g']
			push!(num_to_str_set_map[9], true_char_map[c])
		end

		digit_str = ""
		for str in outputs[i]
			temp = Set()
			for c in str
				push!(temp, c)
			end
			for index in 0:9
				if issetequal(temp, num_to_str_set_map[index])
					digit_str *= string(index)

					break
				end
			end
		end

		digit = parse(Int, digit_str)
		sum += digit
	end

	println("Part 2: ", sum, "\n")
	(sum)
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
