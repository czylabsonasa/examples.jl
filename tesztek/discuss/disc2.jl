using JuMP, GLPK
md = Model(GLPK.Optimizer)
@variable(md, x[1:10,1:20])
b = []
append!(b, 0:9)
a = collect(2:4)
# print("transpose: "); x[a,1]' * b[a] |> println
print("sum: "); x[a,1] .* b[a] |> sum |> println



