###
### trying to resolve the issues with main2.jl
###

# done:
# define set_gtk_properties! for multisetting props
### ok
# cb_store instead of a (master)cb
### ok



### issues from main2:
# DEL: delete a digit or op from the expression (does not not work properly)
##### sol:
##### workaround, it works now for digits and operators, but it wont work for functions
##### (sin...)
# error handling (needs to work with DEL)
# 2^2000, is Int 
##### sol:
##### traverse the expression tree and change all non-symbol leafs to float64
# rethink the parsing, text, and state
##### sol(?):
##### too much hassle with states, why not leave everything to julia?



using Gtk

function set_gtk_properties!(w, props)
  (0==length(props)) && return
  for p in props
    set_gtk_property!(w, p...)
  end
end


let

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


  
  @enum State s_init s_dig s_op s_dot
  state = s_init
  text = "0"

  display = let
    disp = GtkLabel("")
    set_gtk_properties!(disp, [ 
      :xalign =>  0.99,
      :hexpand => true,
      :label => text 
    ])

    push!(
      Gtk.GAccessor.style_context(disp),
      GtkCssProvider(data="* {font-size: 3em;}"), 
      600
    )
    disp
  end

  info = let
    info = GtkLabel("")
    set_gtk_properties!(info, [
      :xalign => 0.05,
      :expand => false,
      :label => "OK"
    ])
    
    push!(
      Gtk.GAccessor.style_context(info),
      GtkCssProvider(data="* {font-size: 1em;}"), 
      600
    )
    info
  end


  # the callbacks 
  function cb_dig(s)
    (state==s_init) && (text="")
    state = s_dig
    text *= s
    set_gtk_property!(display, :label, text)
  end
  function cb_op(s)
    #(state == s_edig) && return
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
  function cb_dot(s)
    (state != s_dig) && return
    state = s_dot
    text *= "."
    set_gtk_property!(display, :label, text)
  end

  function cb_equal(s)
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
  function cb_clear(s)
    state = s_init
    text = "0"
    set_gtk_property!(display, :label, text)
  end

  function cb_del(s)
    ll = text[end]
    if ll in op
      text=text[1:end-2]
    else
      text=text[1:end-1]
    end
    if text==""
      text = "0"
      state = s_init
    else
      ll = text[end]
      if ll in op
        state = s_op
      else
        state = s_dig
      end
    end
    set_gtk_property!(display, :label, text)
  end

  cb_store = Dict(
    "=" => cb_equal,
    "." => cb_dot, 
    "DEL" => cb_del,
    "C" => cb_clear
  )
  merge!(cb_store,
    Dict( v => cb_op for v in op)
  )
  merge!(cb_store,
    Dict(v => cb_dig for v in dig)
  )
  



  # putting all together
  function mkbtn(s)
    btn = GtkButton(s)
    sc = Gtk.GAccessor.style_context(btn)
    cssp = GtkCssProvider(data="* {font-size: 2em;}")  
    push!(sc, cssp, 600)
    set_gtk_property!(btn, :expand, true)
    id = signal_connect(x->cb_store[s](s), btn, "clicked")

    btn
  end

  nrow, ncol = size(btn_plan)
  btn_real = GtkGrid()
  
  for i in 1:nrow
    for j in 1:ncol
      pij = btn_plan[i,j]
      if typeof(pij)==String 
        if length(pij)>0
          btn_real[j,i] = mkbtn(pij)
        else
          continue
        end
      else
        di,dj = pij[2]
        btn_real[j:j+dj,i:i+di] = mkbtn(pij[1])
      end
    end
  end


  vbox = GtkBox(:v)
  push!(vbox, 
    GtkLabel(""), 
    info,
    GtkLabel("")
  )

  disbox = GtkBox(:h)
  push!(disbox, 
    GtkLabel("  "), GtkFrame(display), GtkLabel("  ") 
  )
  
  push!(vbox, 
    disbox, 
    GtkLabel(""),
    btn_real
  )


  win = GtkWindow("Float64-Calculator", 400, 500)
  push!(win, vbox)
  showall(win)

end
