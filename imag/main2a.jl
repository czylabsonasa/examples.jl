using 
  Gtk, 
  Cairo
#, Graphics, Images, Cairo, Colors


let
  argb(a,r,g,b)=UInt32((UInt32(a)<<24)+(UInt32(r)<<16)+(UInt32(g)<<8)+b)
  argb(r,g,b)=UInt32((UInt32(value)<<24)+(UInt32(r)<<16)+(UInt32(g)<<8)+b)

  
  slid = GtkScale(false, 0:255)
  set_gtk_property!(slid, :hexpand, true)
  gas = GAccessor.adjustment(slid)
  value = UInt8(125)
  set_gtk_property!(gas, :value, value)


  cx,cy=200,200

  im = fill(argb(value,120,0,0),cx, cy)


  can = GtkCanvas(cx,cy)
  set_gtk_property!(can, :expand, true)

  gr = GtkGrid()
  gr[1,1] = slid
  gr[1,2] = can
  set_gtk_property!(gr, :expand, true)





  can.draw = function(_)
      buf = fill(argb(value,120,0,0),cx, cy)
      #[argb(x,x>>2,x>>4)  for x in rand(0:255, cx,cy)]
      #image(getgc(can), CairoARGBSurface(buf), 0, 0, cx, cy)
      image(getgc(can), buf, 0, 0, cx, cy)
      
  end
  #show(can)


  signal_connect(slid, :value_changed) do _
    value = get_gtk_property(gas, :value, UInt8)
    #showall(win)
    draw(can)
  end



  win = GtkWindow("Adjust", cx, cy+50)
  push!(win, gr)
  showall(win)
end

