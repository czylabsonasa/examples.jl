
using Reactive, Interact
using Colors, Compose

box(x) = let i = floor(x)
    i%2==0 ? x-i : 1+i-x
end

colors = distinguishable_colors(10, lchoices=[82.])

dots(points) = [(context(p[1], p[2], .05, .05), fill(colors[i%10+1]), circle())
    for (i, p) in enumerate(points)]

@manipulate for t=timestamp(fps(30)), add=button("Add particle"),
    velocities = foldl((x,y) -> push!(x, rand(2)), Any[rand(2)], add)

    compose(context(),
            dots([map(v -> box(v*t[1]), (vx, vy)) for (vx, vy) in velocities])...)
end