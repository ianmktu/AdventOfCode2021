### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ cdeddb50-52d2-11ec-38a8-c5d56295952f
md"""# Day  

"""

# ╔═╡ 1b840d5a-8b64-4b45-8537-849674f9c548
begin		
	println("\nDay ")
	
	script_dir = dirname(Base.@__FILE__)
	input_file = joinpath(script_dir, "input.txt")

	map = Array{Array{Int8}}(undef, countlines(input_file))

	open(input_file) do f
		current_index = 1
		for l in eachline(f)
			number_strings = split(l, "")
			row = Array{Int8}(undef, length(number_strings))
			for (index,str) in enumerate(number_strings)
				row[index] = parse(Int8, str)
			end
        	map[current_index] = row
			current_index += 1
    	end
	end	

end

# ╔═╡ dfe034c8-820c-498b-a227-777515c4cee5
begin		
	local count = 0
	local sum = 0
	for y in 1:length(map)
		# println()
		for x in 1:length(map[1])
			# print(map[y][x])
			if x > 0 && y-1 > 0 && x <= length(map[1]) && y-1 <= length(map) && map[y-1][x] <= map[y][x]
				
				# print("a")
				continue
			elseif x+1 > 0 && y > 0 && x+1 <= length(map[1]) && y <= length(map) && map[y][x+1] <= map[y][x]
				
				# print("b")
				continue
			elseif x > 0 && y+1 > 0 && x <= length(map[1]) && y+1 <= length(map) && map[y+1][x] <= map[y][x]
				
				# print("c")
				continue
			elseif x-1 > 0 && y > 0 && x-1 <= length(map[1]) && y <= length(map) && map[y][x-1] <= map[y][x]
				
				# print("d")
				continue
			end
			# print(map[y][x])

			
			
			count += 1			
			sum += map[y][x]
		end
	end
	println("Part 1: ", sum+count)
	(sum+count)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""

"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	function get_sum(map, x, y, max_x, max_y, picked_map)
		current_sum = 0
		if map[y][x] != 9
			current_sum += 1
			picked_map[string(x) * "," * string(y)] = true
			if x > 0 && y-1 > 0 && x <= length(map[1]) && y-1 <= length(map) && !haskey(picked_map, string(x) * "," * string(y-1))
				current_sum += get_sum(map, x, y-1, max_x, max_y, picked_map)
			end
			
			if x+1 > 0 && y > 0 && x+1 <= length(map[1]) && y <= length(map) && !haskey(picked_map, string(x+1) * "," * string(y))
				current_sum += get_sum(map, x+1, y, max_x, max_y, picked_map)
			end

			if x > 0 && y+1 > 0 && x <= length(map[1]) && y+1 <= length(map) && !haskey(picked_map, string(x) * "," * string(y+1))
				current_sum += get_sum(map, x, y+1, max_x, max_y, picked_map)
			end



			if x-1 > 0 && y > 0 && x-1 <= length(map[1]) && y <= length(map) && !haskey(picked_map, string(x-1) * "," * string(y))
				current_sum += get_sum(map, x-1, y, max_x, max_y, picked_map)
			end
		end

		return current_sum
	end

	basins = Vector{Int}(undef, length(map) * length(map[1]))
	picked_map = Dict{String, Bool}()
	local count = 1
	for y in 1:length(map)
		for x in 1:length(map[1])
			if haskey(picked_map, string(x) * "," * string(y))
				continue
			end
			sum = get_sum(map, x, y, length(map[1]), length(map), picked_map)	
			basins[count] = sum
			count += 1
			
		end
	end

	resize!(basins, count)
	basins = sort(basins)
	product = basins[length(basins)] * basins[length(basins)-1] * basins[length(basins)-2]
	println("Part 2: ", product, "\n")
	(product)
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
