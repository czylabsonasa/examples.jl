# modified
# wop


using Gtk

let

  win = GtkWindow("Calculator")

  dig = [
    "0","1","2","3","4","5","6","7","8","9"
  ]
  op = [
    "+", "-", "*", "/"
  ]

  layout = [
    ["1","2","3","+"],
    ["4","5","6","-"],
    ["7","8","9","*"],
    ["C","0","=","/"],  
  ]
  nrow = length(layout)

  btns = [GtkButton.(layout[i]) for i in 1:nrow]


  @enum State s_empty s_dig s_op
  state = s_empty
  text = "0"

  display = GtkLabel("")
  GAccessor.text(display, text)
  

  # callbacks (cb_)
  function cb_dig(s)
    (s_empty==state) && (text="";state=s_dig)
    text *= s
    GAccessor.text(display, text)
  end
  function cb_op(s)
    (s_dig!=state) && return
    text *= s
    GAccessor.text(display, text)
  end
  function cb_equal()
    (state in [s_empty, s_op]) && return
    text = eval(Meta.parse(text*"*1.0")) |> string
    state = s_dig
    GAccessor.text(display, text)
  end
  function cb_c()
    state = s_empty
    text = "0"
    GAccessor.text(display, text)
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
