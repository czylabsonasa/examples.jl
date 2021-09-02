using Gtk, Graphics, Images, Cairo, Colors

c = GtkCanvas(1000,500)
win = GtkWindow(c, "Canvas")

rgba(a,r,g,b)=UInt32((r<<24)+(g<<16)+(b<<8)+a)

@guarded draw(c) do widget
    ctx = getgc(c)
    #buf = rand(UInt32,150,150)
    #image(ctx, CairoRGBSurface(buf), 0, 0, 150,150)
    #buf = [UInt32((x<<24)+(x<<16)+(x<<8)+255)  for x in rand(0:255, 150,150)]
    buf = [rgba(255,128,255,255)  for x in rand(0:255, 150,150)]
    image(ctx, CairoRGBSurface(buf), 0, 0, 150,150)
end
show(c)
