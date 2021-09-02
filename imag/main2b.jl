using 
  Gtk, 
  Cairo, 
  Observables
#, Graphics, Images, Cairo, Colors


function mkslid(irang, iinit)  
  itip = typeof(iinit)
  oslid = GtkScale(false, irang)
  set_gtk_property!(oslid, :hexpand, true)
  gas = GAccessor.adjustment(oslid)
  set_gtk_property!(gas, :value, iinit)
  ovalue = Observable(iinit)
  h=signal_connect(oslid, :value_changed) do _
    ovalue[] = get_gtk_property(gas, :value, itip)
  end
  oslid, ovalue
end



  argb(a,r,g,b)=UInt32((UInt32(a)<<24)+(UInt32(r)<<16)+(UInt32(g)<<8)+b)
  #argb(r,g,b)=UInt32((UInt32(value)<<24)+(UInt32(r)<<16)+(UInt32(g)<<8)+b)

  


  cx,cy=200,200

  can = GtkCanvas(cx,cy)
  set_gtk_property!(can, :expand, true)

  slid, slidval = mkslid(0:255, UInt8(125))

  on(slidval) do val
    #println("changed to $(val)...")
    draw(can)
  end


  println(typeof(slidval), " ", slidval[])

  #im = fill(argb(slidval[],120,0,0),cx, cy)


  gr = GtkGrid()
  gr[1,1] = slid
  gr[1,2] = can
  set_gtk_property!(gr, :expand, true)


  can.draw = function(_)
      buf = fill(argb(slidval[],120,0,0),cx, cy)
      image(getgc(can), CairoARGBSurface(buf), 0, 0, cx, cy)
  end


  win = GtkWindow("Adjust", cx, cy+50)
  push!(win, gr)
  showall(win)

