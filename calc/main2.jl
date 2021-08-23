# GtkGrid
# powering: ^
# decimal: .
# DEL: delete on character from the expression
# wop


using Gtk

let

  win = GtkWindow("Calculator", 400, 600)

  dig = [
    "0","1","2","3","4","5","6","7","8","9"
  ]

  op = [
    "+", "-", "*", "/", "^"
  ]

  plan = [
    "1"   "2"   "3"    "+"   "C" ;
    "4"   "5"   "6"    "-"   "DEL"  ;
    "7"   "8"   "9"    "*"   ("=",(1,0))  ;
    "."   "0"   "^"    "/"   "" 
  ]



  @enum State s_empty s_dig s_op s_edig
  state = s_empty
  text = "0"

  display = GtkLabel("")
  set_gtk_property!(display, :xalign, 1)
  set_gtk_property!(display, :hexpand, true)
  set_gtk_property!(display, :label, text)
  display_sc = Gtk.GAccessor.style_context(display)
  nagy = GtkCssProvider(data="* {font-size: 3em;}")  
  push!(display_sc, nagy, 600)


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
    (state==s_empty) && (text="")
    state = s_dig
    text *= s
    set_gtk_property!(display, :label, text)
  end
  function cb_op(s)
    (state == s_edig) && return
    if s in ["-","+"]
      (state == s_empty) && (text="") 
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
    (state in [s_empty, s_op]) && return
    text = eval(Meta.parse(text*"*1.0")) |> string
    state = s_dig
    set_gtk_property!(display, :label, text)
  end
  function cb_clear()
    state = s_empty
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


  nrow, ncol = size(plan)
  btns = GtkGrid()
  # set_gtk_property!(btns, :expand, true)
  
  
  for i in 1:nrow
    for j in 1:ncol
      pij = plan[i,j]
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

  dis = GtkBox(:h)
  push!(dis,[GtkLabel(" "), GtkFrame(display), GtkLabel(" ")]...)
  
  push!(vbox, dis)
  push!(vbox, GtkLabel(""))
  push!(vbox, btns)

  push!(win, vbox)


  showall(win)

end
