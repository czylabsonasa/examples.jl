# zipf3.jl
# 

using 
  Gtk, 
  StatsBase, 
  Winston

function compute(data)
  #println(stderr, "compute_xy")
  frek = countmap(data)
  sfrek = sort([(k,v) for (k,v) in frek], by = x->-x[2])
  y = [s[2] for s in sfrek]
  y = y ./ sum(y)
  x = 1:length(y)
  x, y
end


function main()  
  ny = 3 # num of rows
  sx,sy = 0,ny

  top = GtkWindow("top", 800, 600)

  topg = GtkGrid()

  topn = GtkButton("new")
  topq = GtkButton("quit")
  
  workg = GtkGrid()

  topg[1,1] = topn
  topg[2,2] = workg
  topg[3,3] = topq
  push!(top,topg)

  function mknew()
    plt = nothing
    newc = GtkCanvas()
    newb = GtkButton("open")
    newg = GtkGrid()
    newg[1,1] = newb
    newg[2,2] = newc
    
    workg[sx,sy] = GtkFrame("$(sx),$(sy)")
    newf = workg[sx,sy]
    push!(newf, newg)

    set_gtk_property!(newf, :expand, true)
    set_gtk_property!(newc,:expand,true) # expand: must be a child?...


    newbh = signal_connect(newb, :clicked) do widget
      fname = open_dialog("choose a text file")
      data = open(fname, "r") do rd
        split(read(rd, String), x->!isletter(x), keepempty=false) .|> lowercase
      end
      x,y = compute_xy(data)
      title = map(c->c=='_' ? ' ' : c, split(fname,"/")|>last)
      plt = plot(log.(x), log.(y), "r.", title = title)
      p = plot(x,y,"r.")
      display(newc, plt)
      showall(top)
    end
  end
  

  topnh = signal_connect(topn, :clicked) do widget
    sy += 1
    if sy > ny
      sx += 1
      sy = 1
    end

    mknew()
    println(stderr, (sx,sy))

    showall(top)
  end

  topqh = signal_connect(topq, :clicked) do widget
    destroy(top)
  end



  showall(top)
end

main()

