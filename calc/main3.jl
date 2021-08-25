###
### trying to resolve the issues with main2.jl
###

# DONE:
# define set_gtk_properties! for setting multiple props
# cb_store instead of a (master)cb
# introduce add, del, Text
# trav_and_mod + handling integer results
# rounding: only for displayed value


# TODO:
# !!! perhaps no need to plens and ilens !!!! (no, we do need)


using 
  Gtk, 
  Printf


mutable struct Conf
  sigdigits::Int
  tip::DataType
  displim::Int
end
conf = Conf(5,Float64,20)


function trav_and_mod(elem) 
  !isa(elem, Expr) && return
  args = elem.args
  for i in 1:length(args)
    tip = typeof(args[i])
    (tip in [Float64,Symbol]) && continue
    (tip == Int64) && (args[i]=Float64(args[i]); continue)
    trav_and_mod(args[i])
  end
end


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
  ""  "1"   "2"   "3"    "+"   "C"          ""                     ;
  ""           "4"   "5"   "6"    "-"   "DEL"         ""            ;
  ("(",(1,0))   "7"   "8"   "9"    "*"   ("=",(1,0))   (")", (1,0))  ;
  ""           "."   "0"   "^"    "/"   ""            ""  
  ]


  mutable struct Text
    pub::String
    plens::Array{Int}
    inner::String
    ilens::Array{Int}
  end

  text = Text("",[],"",[])

  function add(s::String)
    (state != s_null) && (state = s_null; set_gtk_property!(info, :label, ""))
    si = if s in op " "*s else s end
    text.pub *= s
    push!(text.plens, length(s))
    text.inner *= si
    push!(text.ilens, length(si))
    set_gtk_property!(display, :label, text.pub)
  end

  function del(s::String)
    (state != s_null) && (state = s_null; set_gtk_property!(info, :label, ""))
    (text.pub == "") && return
    text.pub = text.pub[1:end-text.plens[end]]
    pop!(text.plens)
    text.inner = text.inner[1:end-text.ilens[end]]
    pop!(text.ilens)
    set_gtk_property!(display, :label, text.pub)
  end



  display = let
    tmp = GtkLabel("")
    set_gtk_properties!(tmp, [ 
      :xalign =>  0.99,
      :hexpand => true,
      :label => text.pub
    ])

    push!(
      Gtk.GAccessor.style_context(tmp),
      GtkCssProvider(data="* {font-size: 3em;}"), 
      600
    )
    tmp
  end

  info = let
    tmp = GtkLabel("")
    set_gtk_properties!(tmp, [
      :xalign => 0.05,
      :expand => false,
      :label => ""
    ])
    
    push!(
      Gtk.GAccessor.style_context(tmp),
      GtkCssProvider(data="* {font-size: 1em;}"), 
      600
    )
    tmp
  end



  @enum State s_null s_ee
  state = s_null

  
  function cb_equal(s)
    ((state == s_ee) || (text.inner == "")) && return
    
    try
      tree = Meta.parse(text.inner)
      trav_and_mod(tree)
      res = eval(tree)*1.0 # *1.0 if we had a non-expression (constant)
      println(stderr, res, " ", isinteger(res))
      resint = @sprintf "%.0f" res
      text.pub = if isinteger(res) && length(resint)≤conf.displim
        resint
      else
        round(res, sigdigits=conf.sigdigits) |> string
      end
      text.plens = [length(text.pub)]

      set_gtk_property!(display, :label, text.pub)
      text.inner = res |> string
      text.ilens = [length(text.inner)]
    catch
      set_gtk_property!(info, :label, "EE")
      state = s_ee
    end
  end

  function cb_clear(s)
    state = s_null
    text = Text("",[],"",[])
    set_gtk_property!(display, :label, "")
    set_gtk_property!(info, :label, "")
  end


  # the other keys callback is cb_add
  cb_store = Dict(
    "=" => cb_equal,
    "DEL" => del,
    "C" => cb_clear
  )
  



  # putting all together
  function mkbtn(s)
    tmp = GtkButton(s)
    push!(Gtk.GAccessor.style_context(tmp), 
      GtkCssProvider(data="* {font-size: 2em;}"), 
      600
    )
    set_gtk_property!(tmp, :expand, true)
    cb = get(cb_store, s, add)
    id = signal_connect(x->cb(s), tmp, "clicked")

    tmp
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


  win = GtkWindow("Float-Calculator", 400, 500)
  push!(win, vbox)
  @async showall(win)

end
