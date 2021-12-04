# Advent of Code 2021
Solutions to [Advent of Code 2021](https://adventofcode.com/2021). 

Advent of Code is an Advent calendar of small programming puzzles for a variety of skill sets and skill levels that can be solved in any programming language you like. People use them as a speed contest, interview prep, company training, university coursework, practice problems, or to challenge each other.

## Solutions
* Each solution exists in a separate folder for each day, this folder contains the data input and the solution code.
* This year's solutions are done in the Julia programming language
* Each folder has two files
  * Question and Solution File: `main.jl`
  * Data File: `input.txt`
* To run a day from the `AdventOfCode2021` folder from command line: 
```
# Replace $$ with the day you want
julia ./Day$$/main.jl
```
* Alternatively, you can run it as a [Pluto](https://github.com/fonsp/Pluto.jl) notebook instead:
```
# Install Pluto
julia
julia> ]
(v1.7) pkg> add Pluto

# Then start Pluto
julia> import Pluto
julia> Pluto.run()

# Finally, from the Pluto start screen, open a solution file and then run
```
