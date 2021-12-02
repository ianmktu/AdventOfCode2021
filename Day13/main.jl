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
	println("Part 1: ", 0, "\n")
	(0)
end

# ╔═╡ 3d91d0d9-de7e-4aef-9e2d-0e03c96c31ad
md"""

"""

# ╔═╡ 3c9f2b64-b3af-4fa3-b668-0b57aabfad73
begin		
	println("Part 2: ", 0, "\n")
	(0)
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
