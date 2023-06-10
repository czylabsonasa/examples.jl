# a sima modcalc
using Gtk

let

  win = GtkWindow("Calculator2")


  dig = [
    "0","1","2","3","4","5","6","7","8","9"
  ]
  
  op = [
    "+", "-", "*", "/"
  ]

#   layout = [
#     "1" "2" "3" "+" ;
#     "4" "5" "6" "-" ;
#     "7" "8" "9" "*" ;
#     "C","0","=","/"],  
#   ]

#  nrow = length(layout)

#  btns = GtkButton.(layout)

  layout = [
    ["1","2","3","+"],
    ["4","5","6","-"],
    ["7","8","9","*"],
    ["C","0","=","/"],  
  ]
  nrow = length(layout)

  btns = [ GtkButton.(layout[i]) for i in 1:nrow ]



  @enum State s_empty s_dig s_op
  state = s_empty
  text = "0"

  display = GtkLabel("0")
  #set_gtk_property!(display, :editable, false)
  set_gtk_property!(display, :xalign, 0.9 )
  

  # callback
  # perhaps it would be more effective ti define them separately 
  function cb(s)
    while true
      if s in dig
        (s_empty==state) && (text="";state=s_dig)
        text *= s
        break
      end
      if s in op
        if state==s_dig
          text *= s
        end
        break
      end
      if s == "="
        (state in [s_empty, s_op]) && break
        text = eval(Meta.parse(text*"*1.0")) |> string
        state = s_dig
        break
      end
      if s == "C"
        state = s_empty
        text = "0"
        break
      end
    end

    set_gtk_property!(display, :label, text )

  end
  
  


  ids = []  
  for i in 1:nrow
    srow = layout[i]
    brow = btns[i]
    idrow = []
    for j in 1:length(srow)
      s = srow[j]
      b = brow[j]
      if s in dig
        id = signal_connect(x->cb_dig(s), b, "clicked")
        push!(idrow, id)
        continue
      end
      if s in op
        id = signal_connect(x->cb_op(s), b, "clicked")
        push!(idrow, id)
        continue
      end
      if s == "="
        id = signal_connect(x->cb_equal(), b, "clicked")
        push!(idrow, id)
        continue
      end
      if s == "C"
        id = signal_connect(x->cb_c(), b, "clicked")
        push!(idrow, id)
        continue
      end
    end
    push!(ids, idrow)
  end


  hbox = [
    push!(GtkButtonBox(:h), btns[i]...) for i in 1:nrow
  ]

  vbox = GtkBox(:v)
  push!(vbox, GtkLabel(""))
  push!(vbox, display)
  push!(vbox, GtkLabel(""))


  for i in 1:nrow
    push!(vbox, hbox[i])
  end

  push!(win, vbox)

  showall(win)

end
