#!/usr/bin/env julia

function main()
  N = 440_000_000

  table=vcat(0, (1:9).^(1:9))

  for n in 0:N
    ((table[digits(n) .+ 1] |> sum) == n) && println(n)
  end

end # main

main()
