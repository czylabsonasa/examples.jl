using Parameters, Plots, LinearAlgebra, Statistics
gr(fmt = :png)
Agent = @with_kw (kind, location = rand(2))

draw_location!(a) = a.location .= rand(2)

# distance is just 2 norm: uses our subtraction function
get_distance(a, agent) = norm(a.location - agent.location)

function is_happy(a)
    distances = [(get_distance(a, agent), agent) for agent in agents]
    sort!(distances)
    neighbors = [agent for (d, agent) in distances[1:neighborhood_size]]
    share = mean(isequal(a.kind), other.kind for other in neighbors)

    # can also do
    # share = mean(isequal(a.kind),
    #              first(agents[idx]) for idx in
    #              partialsortperm(get_distance.(Ref(a), agents),
    #                              1:neighborhood_size))

    return share ≥ preference
end

function update!(a)
    # If not happy, then randomly choose new locations until happy.
    while !is_happy(a)
        draw_location!(a)
    end
end

function plot_distribution(agents)
    x_vals_0, y_vals_0 = zeros(0), zeros(0)
    x_vals_1, y_vals_1 = zeros(0), zeros(0)

    # obtain locations of each type
    for agent in agents
        x, y = agent.location
        if agent.kind == 0
            push!(x_vals_0, x)
            push!(y_vals_0, y)
        else
            push!(x_vals_1, x)
            push!(y_vals_1, y)
        end
    end

    p = scatter(x_vals_0, y_vals_0, color = :orange, markersize = 2, alpha = 0.6)
    scatter!(x_vals_1, y_vals_1, color = :green, markersize = 2, alpha = 0.6)
    return plot!(legend = :none)
end

num_of_type_0 = 350
num_of_type_1 = 350
neighborhood_size = 30 # Number of agents regarded as neighbors
preference = 0.9 # Want their kind to make at least this share of the neighborhood

# Create a list of agents
agents = vcat([Agent(kind = 0) for i in 1:num_of_type_0],
              [Agent(kind = 1) for i in 1:num_of_type_1])

plot_array = Any[]

# loop until none wishes to move
while true
    push!(plot_array, plot_distribution(agents))
    no_one_moved = true
    for agent in agents
        old_location = copy(agent.location)
        update!(agent)
        if norm(old_location - agent.location) ≉ 0
            no_one_moved = false
        end
    end
    if no_one_moved
        break
    end
end
n = length(plot_array)
plot(plot_array...,
     layout = (n, 1),
     size = (600, 400n),
     title = reshape(["Cycle $i" for i in 1:n], 1, n))