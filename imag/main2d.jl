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

Rslid, Rslidval = mkslid(0:255, UInt8(125))
Gslid, Gslidval = mkslid(0:255, UInt8(125))
Bslid, Bslidval = mkslid(0:255, UInt8(125))

for slidval in [Rslidval, Gslidval, Bslidval]
  on(slidval) do val
    #println("changed to $(val)...")
    draw(can)
  end
end  

#println(typeof(slidval), " ", slidval[])

#im = fill(argb(slidval[],120,0,0),cx, cy)




gr = GtkGrid()
gr[2,2] = Rslid; gr[1,2] = GtkLabel("R")
gr[2,3] = Gslid; gr[1,3] = GtkLabel("G")
gr[2,4] = Bslid; gr[1,4] = GtkLabel("B")
gr[1:2,5:6] = can

set_gtk_property!(gr, :expand, true)


can.draw = function(_)
  ctx = getgc(can)
  rectangle(ctx, 0, 0, width(can), height(can))
  set_source_rgb(ctx, Rslidval[]/255, Gslidval[]/255, Bslidval[]/255)
  fill(ctx)
end


win = GtkWindow("Adjust", cx, 3cy)
push!(win, gr)
showall(win)
