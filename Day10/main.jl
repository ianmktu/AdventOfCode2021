### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day  

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay 10")
	
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
	local error_score = 0

	for l in lines
		tokens_split = split(strip(l), "")

		tokens = Char[]
		for t in tokens_split
			push!(tokens, t[1])
		end

		stack = Char[]		
		for (index, token) in enumerate(tokens)
			if token in ['(', '[', '{', '<']
				push!(stack, token)
			else
				if length(stack) > 0
					matching_open_token = pop!(stack)
					if matching_open_token == '(' && token == ')'
						continue
					elseif matching_open_token == '[' && token == ']'
						continue
					elseif matching_open_token == '{' && token == '}'
						continue
					elseif matching_open_token == '<' && token == '>'
						continue
					end

					if token == ')'
						error_score += 3		
						break
					elseif token == ']'
						error_score += 57
						break
					elseif token == '}'
						error_score += 1197
						break
					elseif token == '>'
						error_score += 25137
						break
					end
				end
			end
		end
	end

	println("Part 1: ", error_score)
	(error_score)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""

"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	local error_score = 0
	local scores = Int[]

	for l in lines
		tokens_split = split(strip(l), "")

		tokens = Char[]
		for t in tokens_split
			push!(tokens, t[1])
		end

		stack = Char[]	
		corrupt = false
		for (index, token) in enumerate(tokens)
			if token in ['(', '[', '{', '<']
				push!(stack, token)
			else
				if length(stack) > 0
					matching_open_token = pop!(stack)
					if matching_open_token == '(' && token == ')'
						continue
					elseif matching_open_token == '[' && token == ']'
						continue
					elseif matching_open_token == '{' && token == '}'
						continue
					elseif matching_open_token == '<' && token == '>'
						continue
					end

					if token == ')'
						error_score += 3		
						corrupt = true		
						break
					elseif token == ']'
						error_score += 57
						corrupt = true
						break
					elseif token == '}'
						error_score += 1197
						corrupt = true
						break
					elseif token == '>'
						error_score += 25137
						corrupt = true
						break
					end
				end
			end
		end

		if !corrupt
			total_score = 0
			for token in reverse(stack)
				total_score *= 5
				if token == '('
					total_score += 1		
				elseif token == '['
					total_score += 2
				elseif token == '{'
					total_score += 3
				elseif token == '<'
					total_score += 4
				end
			end
			push!(scores, total_score)
		end
	end

	sorted_scores = sort!(scores)
	middle = Int(ceil(length(sorted_scores) / 2))

	println("Part 2: ", sorted_scores[middle], "\n")
	(sorted_scores[middle])
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
