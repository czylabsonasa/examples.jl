#
# main.jl
#

using 
  Gtk, 
  StatsBase, 
  Winston


dbg = true



include("general.jl")
include("io.jl")
include("compute.jl")
include("zipf1.jl")
include("zipf2.jl")
include("zipf3.jl")
