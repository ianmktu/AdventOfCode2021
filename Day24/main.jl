### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day 24: Arithmetic Logic Unit
Magic smoke starts leaking from the submarine's arithmetic logic unit (ALU). Without the ability to perform basic arithmetic and logic functions, the submarine can't produce cool patterns with its Christmas lights!

It also can't navigate. Or run the oxygen system.

Don't worry, though - you probably have enough oxygen left to give you enough time to build a new ALU.

The ALU is a four-dimensional processing unit: it has integer variables w, x, y, and z. These variables all start with the value 0. The ALU also supports six instructions:

- inp a - Read an input value and write it to variable a.
- add a b - Add the value of a to the value of b, then store the result in variable a.
- mul a b - Multiply the value of a by the value of b, then store the result in variable a.
- div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
- mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
- eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.

In all of these instructions, a and b are placeholders; a will always be the variable where the result of the operation is stored (one of w, x, y, or z), while b can be either a variable or a number. Numbers can be positive or negative, but will always be integers.

The ALU has no jump instructions; in an ALU program, every instruction is run exactly once in order from top to bottom. The program halts after the last instruction has finished executing.

(Program authors should be especially cautious; attempting to execute div with b=0 or attempting to execute mod with a<0 or b<=0 will cause the program to crash and might even damage the ALU. These operations are never intended in any serious ALU program.)

For example, here is an ALU program which takes an input number, negates it, and stores it in x:

```
inp x
mul x -1
```

Here is an ALU program which takes two input numbers, then sets z to 1 if the second input number is three times larger than the first input number, or sets z to 0 otherwise:

```
inp z
inp x
mul z 3
eql z x
```

Here is an ALU program which takes a non-negative integer as input, converts it into binary, and stores the lowest (1's) bit in z, the second-lowest (2's) bit in y, the third-lowest (4's) bit in x, and the fourth-lowest (8's) bit in w:

```
inp w
add z w
mod z 2
div w 2
add y w
mod y 2
div w 2
add x w
mod x 2
div w 2
mod w 2
```

Once you have built a replacement ALU, you can install it in the submarine, which will immediately resume what it was doing when the ALU failed: validating the submarine's model number. To do this, the ALU will run the MOdel Number Automatic Detector program (MONAD, your puzzle input).

Submarine model numbers are always fourteen-digit numbers consisting only of digits 1 through 9. The digit 0 cannot appear in a model number.

When MONAD checks a hypothetical fourteen-digit model number, it uses fourteen separate inp instructions, each expecting a single digit of the model number in order of most to least significant. (So, to check the model number 13579246899999, you would give 1 to the first inp instruction, 3 to the second inp instruction, 5 to the third inp instruction, and so on.) This means that when operating MONAD, each input instruction should only ever be given an integer value of at least 1 and at most 9.

Then, after MONAD has finished running all of its instructions, it will indicate that the model number was valid by leaving a 0 in variable z. However, if the model number was invalid, it will leave some other non-zero value in z.

MONAD imposes additional, mysterious restrictions on model numbers, and legend says the last copy of the MONAD documentation was eaten by a tanuki. You'll need to figure out what MONAD does some other way.

To enable as many submarine features as possible, find the largest valid fourteen-digit model number that contains no 0 digits. **What is the largest model number accepted by MONAD?**
"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 24: Arithmetic Logic Unit")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	input_instructions = Array{Vector{}}(undef, 14)

	open(input_file) do f
		current_index = 0
		current_alu = Any[]
		current_triplet = Int[]
		for l in eachline(f)
			if occursin("inp w", l) 
				if current_index == 0
					push!(current_alu, split(l, " "))
					current_index += 1
					continue
				end
				input_instructions[current_index] = current_alu
				current_alu = Any[]
				current_index += 1
			end

			push!(current_alu, split(l, " "))
    	end
		input_instructions[current_index] = current_alu
	end	

	
	function print_simplified_equations(input_instructions)
		for i in 1:length(input_instructions)
			println()
			println("Equation ", i)
	
			w = "w"
			x = "x"
			y = "y"
			z = "z"
	
			for j in 1:length(input_instructions[i])
				if j == 1
					continue
				end
	
				func = ""
				if input_instructions[i][j][1] == "mul"
					func = "*"
				elseif input_instructions[i][j][1] == "add"
					func = "+"
				elseif input_instructions[i][j][1] == "div"
					func = "/"
				elseif input_instructions[i][j][1] == "mod"
					func = "%"
				elseif input_instructions[i][j][1] == "eql"
					func = "=="
				end
	
				if func != ""
					if input_instructions[i][j][3] == "w"
						input = w 
					elseif input_instructions[i][j][3] == "x"
						input = x 
					elseif input_instructions[i][j][3] == "y"
						input = y 
					elseif input_instructions[i][j][3] == "z"
						input = z 
					else
						input = input_instructions[i][j][3]
					end
				end
	
				if func == "*" && input == "0"
					if input_instructions[i][j][2] == "w"
						w = "0"
					elseif input_instructions[i][j][2] == "x"
						x = "0"
					elseif input_instructions[i][j][2] == "y"
						y = "0"
					elseif input_instructions[i][j][2] == "z"
						z = "0"
					end
					continue
				end
	
				if func == "+" 
					if input_instructions[i][j][2] == "w" && w == "0"
						w = input_instructions[i][j][3]
						continue
					elseif input_instructions[i][j][2] == "x" && x == "0"
						x = input_instructions[i][j][3]
						continue
					elseif input_instructions[i][j][2] == "y" && y == "0"
						y = input_instructions[i][j][3]
						continue
					elseif input_instructions[i][j][2] == "z" && z == "0"
						z = input_instructions[i][j][3]
						continue
					end				
				end
	
				if func == "/" && input == "1"
					continue
				end
	
				if func != ""
					if input_instructions[i][j][2] == "w"
						w = "(" * w * func * input * ")"
					elseif input_instructions[i][j][2] == "x"
						x = "(" * x * func * input * ")"
					elseif input_instructions[i][j][2] == "y"
						y = "(" * y * func * input * ")"
					elseif input_instructions[i][j][2] == "z"
						z = "(" * z * func * input * ")"
					end
				end
			end
	
			y = replace(y, x => "x")
			z = replace(z, x => "x")
			z = replace(z, y => "y")
	
			println("w = ", w)
			println("x = ", x)
			println("y = ", y)
			println("z = ", z)
			println()
		end
	end
	
	# Uncomment line below to print out original equations
	# print_simplified_equations(input_instructions)

	input_instructions_simplified = Array{Vector{Integer}}(undef, 14)
	for i in 1:14
		triplet = Int[]
		for (index, equation) in enumerate(input_instructions[i])			
			# Used print_simplified_equations(input_instructions) to find the equations first
			# Only need 3 values from each input block, the divisor, x_constant, y_constant
			if index in [5, 6, 16]
				push!(triplet, parse(Int, equation[3]))
			end
		end
		input_instructions_simplified[i] = triplet
	end
end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin	
	function simplified_equation(inputs, w, z)
		divisor = inputs[1]
		x_addition = inputs[2]
		y_addition = inputs[3]

		# Original form
		# x = if (((z % divisor) + x_addition == w) == 0) 1 else 0 end
		# y = (w + y_addition) * x
		# z = ((div(z, divisor)*((25*x)+1))+y)

		if ((z % divisor) + x_addition) == w
			z = div(z, divisor)
		else
			z = div(z, divisor) * 26 + w + y_addition
		end

		return z
	end

	using HDF5, JLD
	dict_file = joinpath(script_dir, "data.jld")
	if !isfile(dict_file)
		z_found = Dict(14 => Set([0]))
		t = @elapsed begin		
			for i in 14:-1:1
				println("\nAt block: ", i)
				
				z_to_find = Set{Int}([])

				# Increase z-value search if no value is found at block 1 (must be 0 in the set)
				Threads.@threads for z in 0:10000000
					for w in 1:9			
						z_result = simplified_equation(input_instructions_simplified[i], w, z)	
						
						if in(z_result, z_found[i])
							push!(z_to_find, z)
							continue
						end

					end
				end

				z_found[i-1] = z_to_find
				println("Found values of z: ", length(z_to_find))
			end
			save("data.jld", "data", z_found)			
		end
		println("\nTime taken: ", t, " secs\n")
	else
		z_found = load("data.jld")["data"]
	end

	local z = 0
	local num_str = ""
	for digit in 1:14
		for w in 9:-1:1
			z_result = simplified_equation(input_instructions_simplified[digit], w, z)	
			if in(z_result, z_found[digit])
				z = z_result
				num_str *= string(w)
				break
			end			
		end
	end

	println("Part 1: ", num_str)
	(num_str)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""
As the submarine starts booting up things like the Retro Encabulator, you realize that maybe you don't need all these submarine features after all.

**What is the smallest model number accepted by MONAD?**
"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	local z = 0
	local num_str = ""
	for digit in 1:14
		for w in 1:9
			z_result = simplified_equation(input_instructions_simplified[digit], w, z)	
			if in(z_result, z_found[digit])
				z = z_result
				num_str *= string(w)
				break
			end			
		end
	end

	println("Part 2: ", num_str, "\n")
	(num_str)
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
