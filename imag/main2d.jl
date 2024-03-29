# grayscale play

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

RGBslid, RGBslidval = mkslid(0:255, UInt8(125))

on(RGBslidval) do val
  draw(can)
end


gr = GtkGrid()
gr[1,2] = GtkLabel("RGB"); gr[2,2] = RGBslid
gr[1:2,5:6] = can

set_gtk_property!(gr, :expand, true)


can.draw = function(_)
  ctx = getgc(can)
  rectangle(ctx, 0, 0, width(can), height(can))
  set_source_rgb(ctx, RGBslidval[]/255, RGBslidval[]/255, RGBslidval[]/255)
  fill(ctx)
end


win = GtkWindow("Adjust", cx, 3cy)
push!(win, gr)
showall(win)
