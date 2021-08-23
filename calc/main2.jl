# GtkGrid
# powering: ^
# decimal: .
# font-size ok
# DEL: delete a character from the expression (does not not working properly)
# error handling (needs to work with DEL)
# 2^2000, is Int
# rethink the parsing, text, and state
# 


using Gtk

let

  win = GtkWindow("Calculator", 400, 500)

  dig = [
    "0","1","2","3","4","5","6","7","8","9"
  ]

  op = [
    "+", "-", "*", "/", "^"
  ]

  btn_plan = [
    "1"   "2"   "3"    "+"   "C" ;
    "4"   "5"   "6"    "-"   "DEL"  ;
    "7"   "8"   "9"    "*"   ("=",(1,0))  ;
    "."   "0"   "^"    "/"   ""
  ]


  @enum State s_init s_dig s_op s_edig
  state = s_init
  text = "0"

  display = let
    disp = GtkLabel("")
    set_gtk_property!(disp, :xalign, 0.99)
    set_gtk_property!(disp, :hexpand, true)
    set_gtk_property!(disp, :label, text)
    push!(
      Gtk.GAccessor.style_context(disp),
      GtkCssProvider(data="* {font-size: 3em;}"), 
      600
    )
    disp
  end

  info = let
    info = GtkLabel("")
    set_gtk_property!(info, :xalign, 0.05)
    set_gtk_property!(info, :expand, false)
    set_gtk_property!(info, :label, "OK")
    push!(
      Gtk.GAccessor.style_context(info),
      GtkCssProvider(data="* {font-size: 1em;}"), 
      600
    )
    info
  end


  # the main callback
  function cb(s)
    while true
      if s in dig
        cb_dig(s)
        break
      end
      if s in op
        cb_op(s)
        break
      end
      if s == "="
        cb_equal()
        break
      end
      if s == "C"
        cb_clear()
        break
      end

      if s == "."
        cb_dot()
        break
      end

      if s == "DEL"
        cb_del()
        break
      end

    end
  end

  # the callbacks 
  function cb_dig(s)
    (state==s_init) && (text="")
    state = s_dig
    text *= s
    set_gtk_property!(display, :label, text)
  end
  function cb_op(s)
    (state == s_edig) && return
    if s in ["-","+"]
      (state == s_init) && (text="") 
    else
      (state != s_dig) && return
    end
    state = s_op
    s = " "*s

    text *= s
    set_gtk_property!(display, :label, text)
  end
  function cb_dot()
    (state != s_dig) && return
    state = s_edig
    text *= "."
    set_gtk_property!(display, :label, text)
  end

  function cb_equal()
    (state == s_init) && return
    try
      text = eval(Meta.parse(text*"*1.0")) |> string
      state = s_dig
      set_gtk_property!(display, :label, text)
      set_gtk_property!(info, :label, "OK")
    catch
      set_gtk_property!(info, :label, "EE")
    end
  end
  function cb_clear()
    state = s_init
    text = "0"
    set_gtk_property!(display, :label, text)
  end

  function cb_del()
    (length(text)>1) && (text=text[1:end-1])
    set_gtk_property!(display, :label, text)
  end




  function mkbtn(s)
    btn = GtkButton(s)
    btn_sc = Gtk.GAccessor.style_context(btn)
    nagy = GtkCssProvider(data="* {font-size: 2em;}")  
    push!(btn_sc, nagy, 600)
    set_gtk_property!(btn, :expand, true)
    id = signal_connect(x->cb(s), btn, "clicked")

    btn
  end


  nrow, ncol = size(btn_plan)
  btns = GtkGrid()
  # set_gtk_property!(btns, :expand, true)
  
  
  for i in 1:nrow
    for j in 1:ncol
      pij = btn_plan[i,j]
      if typeof(pij)==String 
        if length(pij)>0
          #b = GtkButton(s)
          #set_gtk_property!(b, :expand, true)
          btns[j,i] = mkbtn(pij)
        else
          continue
        end
      else
        di,dj = pij[2]
        #btns[j:j+dj,i:i+di] = b
        btns[j:j+dj,i:i+di] = mkbtn(pij[1])
        
      end
    end
  end



  vbox = GtkBox(:v)
  push!(vbox, GtkLabel(""))
  push!(vbox, info)
  push!(vbox, GtkLabel(""))

  dis = GtkBox(:h)
  push!(dis,[GtkLabel("  "), GtkFrame(display), GtkLabel("  ")]...)
  
  push!(vbox, dis)
  push!(vbox, GtkLabel(""))
  push!(vbox, btns)

  push!(win, vbox)


  showall(win)

end
