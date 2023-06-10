using Gtk

let    
  welcome_Window_Main = GtkWindow("hi", 200, 400)    

  grid_Layout_Welcome_Window = GtkGrid()
  #set_gtk_property!(grid_Layout_Welcome_Window)
  set_gtk_property!(grid_Layout_Welcome_Window, :column_spacing, 10)
  
  A_button = GtkButton("Click Me A")
  B_button = GtkButton("Click Me B")
  C_button = GtkButton("Click Me C")
  D_button = GtkButton("Click Me D")
  E_button = GtkButton("Click Me E")
  btns = [A_button,B_button,C_button,D_button,E_button]
  for b in btns
    set_gtk_property!(b, :expand, true)
  end


  grid_Layout_Welcome_Window[1:10,1:50] = A_button
  grid_Layout_Welcome_Window[20:90,1:10] = B_button
  grid_Layout_Welcome_Window[70:80,50:70] = C_button
  grid_Layout_Welcome_Window[80:90,70:300] = D_button
  grid_Layout_Welcome_Window[10:20,10:30] = E_button
  

  push!(welcome_Window_Main,grid_Layout_Welcome_Window)

  showall(welcome_Window_Main)
end

