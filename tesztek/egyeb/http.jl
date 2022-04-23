using HTTP

urls = [
  "https://discourse.julialang.org/", 
  "https://hup.hu/",
  "https://index.hu",
  "https://rt.com",
  "https://bbc.com",
]

function fun1()
  results1 = []
  for url in urls
      resp = HTTP.request("GET", url; verbose=0);
      println(stderr, url*"..."*string(resp.status))
      push!(results1, resp)
  end
end

function fun2()
  results2 = []
  @sync for url in urls
    @async begin 
      resp = HTTP.request("GET", url; verbose=0);
      println(stderr, url*"..."*string(resp.status))
      push!(results2, resp)
    end
  end
end

@time fun1()
@time fun2()

