### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 3: Binary Diagnostic

The submarine has been making some odd creaking noises, so you ask it to produce a diagnostic report just in case.

The diagnostic report (your puzzle input) consists of a list of binary numbers which, when decoded properly, can tell you many useful things about the conditions of the submarine. The first parameter to check is the power consumption.

You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate). The power consumption can then be found by multiplying the gamma rate by the epsilon rate.

Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report. For example, given the following diagnostic report:

```
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
```

Considering only the first bit of each number, there are five 0 bits and seven 1 bits. Since the most common bit is 1, the first bit of the gamma rate is 1.

The most common second bit of the numbers in the diagnostic report is 0, so the second bit of the gamma rate is 0.

The most common value of the third, fourth, and fifth bits are 1, 1, and 0, respectively, and so the final three bits of the gamma rate are 110.

So, the gamma rate is the binary number 10110, or 22 in decimal.

The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used. So, the epsilon rate is 01001, or 9 in decimal. Multiplying the gamma rate (22) by the epsilon rate (9) produces the power consumption, 198.

Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together. What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.)
"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 3:")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	lines = Array{String}(undef, countlines(input_file))

	open(input_file) do f
		current_index = 1
		for l in eachline(f)
        	lines[current_index] = l
			current_index += 1
    	end
	end	
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	local dict = Dict{Int64, Int64}()
	for binary_num_str in lines
		for digit in 1:length(binary_num_str)
			if !haskey(dict, digit)
				dict[digit] = 0
			end		
			if binary_num_str[digit] == '1'
				dict[digit] += 1
			end
		end
	end


	gamma_binary_str = ""
	epsilon_binary_str = ""
	for digit in 1:length(dict)
		if dict[digit] < length(lines)/2
			gamma_binary_str *= "0"
			epsilon_binary_str *= "1"
		else
			gamma_binary_str *= "1"
			epsilon_binary_str *= "0"
		end
	end

	println(typeof(gamma_binary_str))
	gamma = parse(Int64, gamma_binary_str; base=2)
	epsilon = parse(Int64, epsilon_binary_str; base=2)	
	consumption = gamma * epsilon
	
	println("Part 1: ", consumption, "\n")
	("gamma" => gamma, "epsilon" => epsilon, "consumption" => consumption)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""
Next, you should verify the life support rating, which can be determined by multiplying the oxygen generator rating by the CO2 scrubber rating.

Both the oxygen generator rating and the CO2 scrubber rating are values that can be found in your diagnostic report - finding them is the tricky part. Both values are located using a similar process that involves filtering out values until only one remains. Before searching for either rating value, start with the full list of binary numbers from your diagnostic report and consider just the first bit of those numbers. Then:

- Keep only numbers selected by the bit criteria for the type of rating value for which you are searching. Discard numbers which do not match the bit criteria.
- If you only have one number left, stop; this is the rating value for which you are searching.
- Otherwise, repeat the process, considering the next bit to the right.


The bit criteria depends on which type of rating value you want to find:
- To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 1 in the position being considered.
- To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 0 in the position being considered.

For example, to determine the oxygen generator rating value using the same example diagnostic report from above:

- Start with all 12 numbers and consider only the first bit of each number. There are more 1 bits (7) than 0 bits (5), so keep only the 7 numbers with a 1 in the first position: 11110, 10110, 10111, 10101, 11100, 10000, and 11001.
- Then, consider the second bit of the 7 remaining numbers: there are more 0 bits (4) than 1 bits (3), so keep only the 4 numbers with a 0 in the second position: 10110, 10111, 10101, and 10000.
- In the third position, three of the four numbers have a 1, so keep those three: 10110, 10111, and 10101.
- In the fourth position, two of the three numbers have a 1, so keep those two: 10110 and 10111.
- In the fifth position, there are an equal number of 0 bits and 1 bits (one each). So, to find the oxygen generator rating, keep the number with a 1 in that position: 10111.
- As there is only one number left, stop; the oxygen generator rating is 10111, or 23 in decimal.


Then, to determine the CO2 scrubber rating value from the same example above:

- Start again with all 12 numbers and consider only the first bit of each number. There are fewer 0 bits (5) than 1 bits (7), so keep only the 5 numbers with a 0 in the first position: 00100, 01111, 00111, 00010, and 01010.
- Then, consider the second bit of the 5 remaining numbers: there are fewer 1 bits (2) than 0 bits (3), so keep only the 2 numbers with a 1 in the second position: 01111 and 01010.
- In the third position, there are an equal number of 0 bits and 1 bits (one each). So, to find the CO2 scrubber rating, keep the number with a 0 in that position: 01010.
- As there is only one number left, stop; the CO2 scrubber rating is 01010, or 10 in decimal.

Finally, to find the life support rating, multiply the oxygen generator rating (23) by the CO2 scrubber rating (10) to get 230.

Use the binary numbers in your diagnostic report to calculate the oxygen generator rating and CO2 scrubber rating, then multiply them together. What is the life support rating of the submarine? (Be sure to represent your answer in decimal, not binary.)
"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	oxygen_binary_str = ""
	current_binary_str = ""
	for digit in 1:length(lines[1])
		counter = 0
		current_total = 0
		skipped = 0
		for binary_num_str in lines
			skip = false

			for skip_index in 1:length(oxygen_binary_str)
				if oxygen_binary_str[skip_index] != binary_num_str[skip_index]
					skip = true
					break
				end
			end
			
			if skip
				skipped += 1
				continue
			end
			
			if binary_num_str[digit] == '1'				
				counter += 1
			end

			current_binary_str = binary_num_str
			current_total += 1			
		end

		if counter < (current_total/2)
			oxygen_binary_str *= "0"
		else
			oxygen_binary_str *= "1"
		end

		if current_total == 1
			break
		end
	end

	oxygen = parse(Int64, current_binary_str; base=2)	



	co2_binary_str = ""
	current_binary_str = ""
	for digit in 1:length(lines[1])
		counter = 0
		current_total = 0
		skipped = 0
		for binary_num_str in lines
			skip = false

			for skip_index in 1:length(co2_binary_str)
				if co2_binary_str[skip_index] != binary_num_str[skip_index]
					skip = true
					break
				end
			end
			
			if skip
				skipped += 1
				continue
			end
			
			if binary_num_str[digit] == '1'				
				counter += 1
			end

			current_binary_str = binary_num_str
			current_total += 1			
		end

		if counter < (current_total/2)
			co2_binary_str *= "1"
		else
			co2_binary_str *= "0"
		end

		if current_total == 1
			break
		end
	end

	co2 = parse(Int64, current_binary_str; base=2)	
	life_support_rating = oxygen * co2
	
	println("Part 2: ", life_support_rating, "\n")
	("oxygen" => oxygen, "co2" => co2, "life_support_rating" => life_support_rating)
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
