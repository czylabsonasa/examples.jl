### A Pluto.jl notebook ###
# v0.14.7

# import Pkg;
# Pkg.add.(split("Luxor Colors StaticArrays Random Markdown InteractiveUtils"))


using Markdown
#using InteractiveUtils

# ╔═╡ 8e0ed9fc-c31d-11eb-262f-cb01121c7f1f
using Luxor, Colors, StaticArrays, Random

# ╔═╡ f9594968-41de-4be6-8052-68f0d87e74bc
@draw let
	origin()
	for i in (-140, 140), j in (-140, 140)
		line(Point([i+10, j+10]...), Point([i*j/140, -j]...), :path)
	end
	strokepath()
	rulers()
	rect(10, 10, -100, -100, :path)
	setcolor("white")
	fillpreserve()
	setcolor("black")
	strokepreserve()
end

# ╔═╡ b8a1f5c9-7d55-41eb-9061-54ebacfe3a9b
Vec2 = SVector{2, Float64}

# ╔═╡ 481e8e27-6def-4132-9436-6831cb8a9e8a
Vec3 = SVector{3, Float64}

# ╔═╡ cbc8cb57-e75b-4770-a5e1-4bb3d22ee4c5
mutable struct Cam
	pos ::Vec3
	look ::Float64
	horizon :: Float64
end

# ╔═╡ cbae909d-6a99-4307-bb05-aae48ec7a5a6
gcam = Cam([0, 0, 0], 0, 0)

# ╔═╡ 71cbec91-c56c-42c7-83c5-436f99de373a
function pers(cam ::Cam, v ::Vec3)
	v -= cam.pos
	v = [cos(cam.look) 0 sin(cam.look); 0 1 0; -sin(cam.look) 0 cos(cam.look)] * v
	return @SVector[
		v[1]/v[3],
		v[2]/v[3] + cam.horizon
	]
end

# ╔═╡ 27ac47f4-7cd8-4b5b-b425-1ab76f06be4e
pers(v ::Vec3) = pers(gcam, v)

# ╔═╡ 080e0250-c819-428d-a8e1-433d847c5dd9
pers(x, y, z) = pers([x, y, z])

# ╔═╡ c519a416-538b-42ca-93a4-8480c798ef22
line_pers(a ::Vec3, b ::Vec3, x...) = line(Point(pers(a)...), Point(pers(b)...), x...)

# ╔═╡ 5c9fcee8-3a9a-4660-878a-cc788d59a469
@draw let
	scale(280, -280)
	
	#line_pers(Vec3(1, 0, 1), Vec3(1, 1, 2), :stroke)
	
	gcam.pos = [1.5, 1.9, -2]
	
	#move(v ::Vec3) = v - Vec3(3, 4, -2)
	
	
	for x in (0, 1), y in (0, 1), z in (0, 1)
		p = Vec3(x, y, z)
		px = Vec3(1-x, y, z)
		py = Vec3(x, 1-y, z)
		pz = Vec3(x, y, 1-z)
		for p2 in (px, py, pz)
			line_pers(p, p2, :stroke)
		end
		line_pers(Vec3(x, 0, 0), Vec3(1-x, 1, 0), :stroke)
	end
	
end

# ╔═╡ 8016f5b8-5bba-4248-997a-4f44bcf3f005
function poly_pers(points...; filc = "white")
	cam = gcam
	pp = [pers(cam, Vec3(pt...)) for pt in points]
	if (pp[2] - pp[1])[1] * (pp[3] - pp[1])[2] - (pp[2] - pp[1])[2] * (pp[3] - pp[1])[1] < 0
		return
	end
	poly([Point(p[1], p[2]) for p in pp], close=true) 
	setcolor(filc)
	fillpreserve()
	setcolor("black")
	strokepath()
end

# ╔═╡ c3ee2fff-673b-4a06-a76b-87ad8e32b4bc
function rcube(xmin, ymin, zmin, xmax, ymax, zmax)
	bym = ((xmin, ymin, zmin), (xmax, ymax, zmax))
	byc = ((xmin, xmax), (ymin, ymax), (zmin, zmax))
	poly_pers(Vec3(xmin, ymin, zmin), Vec3(xmax, ymin, zmin), Vec3(xmax, ymax, zmin), Vec3(xmin, ymax, zmin), filc="grey")
	poly_pers(Vec3(xmin, ymin, zmax), Vec3(xmin, ymax, zmax), Vec3(xmax, ymax, zmax), Vec3(xmax, ymin, zmax))
	poly_pers(Vec3(xmin, ymin, zmin), Vec3(xmin, ymin, zmax), Vec3(xmax, ymin, zmax), Vec3(xmax, ymin, zmin), filc="black")
	poly_pers(Vec3(xmin, ymax, zmin), Vec3(xmax, ymax, zmin), Vec3(xmax, ymax, zmax), Vec3(xmin, ymax, zmax))
	poly_pers(Vec3(xmin, ymin, zmin), Vec3(xmin, ymax, zmin), Vec3(xmin, ymax, zmax), Vec3(xmin, ymin, zmax))
	poly_pers(Vec3(xmax, ymin, zmin), Vec3(xmax, ymin, zmax), Vec3(xmax, ymax, zmax), Vec3(xmax, ymax, zmin))
end

# ╔═╡ 5dbf6163-cc30-4edc-8150-99c869ab75d2
@draw let
	scale(280, -280)
	setline(0.5)
	gcam.pos = Vec3(0, 0, -2)
	rcube(-1.5, -1.5, 0, -0.5, -0.5, 1)
	rcube(-1.5, 0.5, 0, -0.5, 1.5, 1)
	#rcube(1.5, -1.5, 0, 0.5, -0.5, 1)
	rcube(0.5, 0.5, 0, 1.5, 1.5, 1)
	#rcube(-1.5, -1.5, 0, -0.5, -0.5, 1)
	#rcube(0, 2.1, 0, 0, 2, 1)
end

# ╔═╡ 70cf0fbd-f7a0-42dd-8651-e06159b4e356
function build1(xmin, ymin, zmin, xmax, ymax, zmax; floor = 5, iwid = 1/10, fwid = 1/2)
	xl = xmax - xmin
	yl = ymax - ymin
	zl = zmax - zmin
	iwid /= 2
	for i in floor-1:-1:0
		rcube(xmin + xl*iwid, ymin + yl/(floor) * (i + fwid), zmin + zl*iwid, xmax - xl*iwid, ymin + yl/floor * (i + 1), zmax - zl*iwid)
		rcube(xmin, ymin + yl/floor * (i), zmin, xmax, ymin + yl/floor * (i+fwid), zmax)
	end
end

# ╔═╡ 57cdb10d-1fa3-4d77-b828-2c7ae860189a
@draw let
	gcam.pos = (-3, 0, -3)
	gcam.look = -pi/4
	gcam.horizon = -1
	scale(280, -280)
	setline(0.5)
	build1(-1.05, 0, 0, -0.05, 3.05, 1, floor=10, iwid=0.06, fwid=0.8)
end

# ╔═╡ 8cd42c92-e796-4590-be7b-4642255aced4
@draw let
	gcam.pos = (-3, 0, -3)
	gcam.look = -pi/4
	gcam.horizon = -1
	scale(280, -280)
	setline(0.5)
	Random.seed!(1337)
	for x in 30:-1:0, z in 30:-1:0
		if(rand() > 0.5) continue end
		build1(x+0.1, 0, z+0.1, x+0.9, rand(0:0.1:(x+z)/1.5), z+0.9, floor=rand(1:10), iwid=rand(), fwid=rand())
	end
end

# ╔═╡ e5799484-1718-47ac-b840-5e12518d7909
@png let
	origin()
	background("black")
	gcam.pos = (-3, 0, -3)
	gcam.look = -pi/4
	gcam.horizon = -0.5
	scale(1000, -1000)
	setline(0.5)
	Random.seed!(1337)
	for x in 30:-1:0, z in 30:-1:0
		if(rand() > 0.5) continue end
		build1(x+0.1, 0, z+0.1, x+0.9, rand(0:0.1:(x+z)/1.5), z+0.9, floor=rand(1:10), iwid=rand(), fwid=rand())
	end
end 1920 1080 "black-buildings.png"

# ╔═╡ Cell order:
# ╠═8e0ed9fc-c31d-11eb-262f-cb01121c7f1f
# ╠═f9594968-41de-4be6-8052-68f0d87e74bc
# ╠═b8a1f5c9-7d55-41eb-9061-54ebacfe3a9b
# ╠═481e8e27-6def-4132-9436-6831cb8a9e8a
# ╠═cbc8cb57-e75b-4770-a5e1-4bb3d22ee4c5
# ╠═cbae909d-6a99-4307-bb05-aae48ec7a5a6
# ╠═71cbec91-c56c-42c7-83c5-436f99de373a
# ╠═27ac47f4-7cd8-4b5b-b425-1ab76f06be4e
# ╠═080e0250-c819-428d-a8e1-433d847c5dd9
# ╠═c519a416-538b-42ca-93a4-8480c798ef22
# ╠═5c9fcee8-3a9a-4660-878a-cc788d59a469
# ╠═8016f5b8-5bba-4248-997a-4f44bcf3f005
# ╠═c3ee2fff-673b-4a06-a76b-87ad8e32b4bc
# ╠═5dbf6163-cc30-4edc-8150-99c869ab75d2
# ╠═70cf0fbd-f7a0-42dd-8651-e06159b4e356
# ╠═57cdb10d-1fa3-4d77-b828-2c7ae860189a
# ╠═8cd42c92-e796-4590-be7b-4642255aced4
# ╠═e5799484-1718-47ac-b840-5e12518d7909
