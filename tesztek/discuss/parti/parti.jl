using Combinatorics, BenchmarkTools, BenchmarkPlots, StatsPlots

function gustaphe_combinations!(list, root, N; unique=true)
    if iszero(N)
        return push!(list, root)
    end
    start = isempty(root) ? 1 : last(root) + unique
    for n = start:N
        arr = vcat(root, n)
        gustaphe_combinations!(list, arr, N-n)
    end
end

function gustaphe_combinations(N; unique=true)
    list = Vector{Int64}[]
    gustaphe_combinations!(list, Int64[], N; unique)
    return list
end

function mschauer_combinations(N; unique=true)
    p = partitions(N)
    unique && return collect(Iterators.filter(allunique, p))
    return collect(p)
end

function benchmarkcombinatorics(N)
    suite = BenchmarkGroup()
    suite[:gustapheunique] = @benchmarkable gustaphe_combinations($N; unique=true)
    suite[:gustaphenonunique] = @benchmarkable gustaphe_combinations($N; unique=false)
    suite[:mschauerunique] = @benchmarkable mschauer_combinations($N; unique=true)
    suite[:mschauernonunique] = @benchmarkable mschauer_combinations($N; unique=false)
    res = run(suite)
    plot(res, [:gustapheunique, :gustaphenonunique, :mschauerunique, :mschauernonunique]; yscale=:log10, fontfamily="Computer Modern")
end