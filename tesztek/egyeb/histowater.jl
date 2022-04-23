let
  N = 30
  R = 30
  bars = rand(1:R, N)
  mom = fill(typemax(Int), N)
  mom[1] = bars[1]
  mom[N] = bars[N]
  l, r = 2, N-1
  while r>0
    mom[r] = min( max(bars[r], mom[r+1]), mom[r] )
    mom[l] = min( max(bars[l], mom[l-1]), mom[l] )
    r -= 1
    l += 1
  end

  using 
    Plots, 
    StatsPlots

  # bar(
  #   bars, xticks = (1:N, 1:N), legend = :outertopright, colour = fill("green", N)
  # )
  A, B = bars, mom .- bars

  groupedbar(
    [B A], 
    #xticks = (1:N, 1:N), 
    xticks = nothing,
    legend = :outertopright, 
    bar_position = :stack, 
    label = ["water" "bars"]
  )
  
end

