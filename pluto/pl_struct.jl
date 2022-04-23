### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 5a6df336-bf2b-11ec-09c5-572ed0c2db0d
begin
struct Foo
	x::Int
	name::String
end
Base.string(x::Foo)=x.name
Base.show(io::IO, x::Foo) = print(io, x.name)
end

# ╔═╡ af91dbf4-49e6-4cde-9b73-310bab3b883e
begin	
	asd=Foo(1,"egy")
	#asd=sin
	md"""$(asd)"""
end

# ╔═╡ fd368d27-b7ee-4572-8a88-a70b45c0945f
string(asd)

# ╔═╡ Cell order:
# ╠═5a6df336-bf2b-11ec-09c5-572ed0c2db0d
# ╠═af91dbf4-49e6-4cde-9b73-310bab3b883e
# ╠═fd368d27-b7ee-4572-8a88-a70b45c0945f
