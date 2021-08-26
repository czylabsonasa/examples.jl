###
### trying to resolve the issues with main2.jl
###

# DONE:
# define set_gtk_properties! for setting multiple props
# cb_store instead of a (master)cb
# introduce add, del, Text
# trav_and_mod + handling integer results
# rounding: only for displayed value
### a bit messy: integer vs. decimal form (digits) vs. exponential form (sigdigits)


# TODO:
# !!! perhaps no need to plens and ilens !!!! (no, we do need)
# some common functions

using 
  Gtk, 
  Printf


mutable struct Options
  sigdigits::Int
  tip::DataType
  displim::Int
  trigfun::String
end
opts = Options(5,Float64,20,"rad")


# function trav_and_mod(elem)
  # !isa(elem, Expr) && return
  # args = elem.args
  # for i in 1:length(args)
    # tip = typeof(args[i])
    # (tip in [Float64,Symbol]) && continue
    # (tip == Int64) && (args[i]=Float64(args[i]); continue)
    # trav_and_mod(args[i])
  # end
# end


# 
function trav_and_mod(elem)
  !isa(elem, Expr) && return
  args = elem.args
  for i in 1:length(args)
    (typeof(args[i]) == Int64) && (args[i]=Float64(args[i]); continue)
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


  trigfun = [
    "sin", "cos", "tan", "cot",
    "asin", "acos", "atan", "acot"
  ]

  genfun = [
    "exp", 
    "log", "log2", "log10"
  ]
  

  btn_plan = [
    "("     "1"     "2"       "3"     "+"     "C"       ")"       ;
    ""      "4"     "5"       "6"     "-"     "DEL"     ""        ;
    ""      "7"     "8"       "9"     "*"     "="       ""        ;
    ""      "."     "0"       "^"     "/"     ""        ""        ;
    "sin"   "cos"   "tan"     "cot"   "exp"   ""        ""        ;
    "asin"  "acos"  "atan"    "acot"  "log"   "log2"    "log10"
  ]
  
  btn_size=Dict(
#    "(" => (0,0),
    "=" => (1,0),
#    ")" => (0,0)
  )


  mutable struct Text
    pub::String
    plens::Array{Int}
    inner::String
    ilens::Array{Int}
  end

  text = Text("",[],"",[])

  function add(s::String)
    (state != s_null) && (state = s_null; set_gtk_property!(info, :label, ""))
    sp, si = if s in op 
        s, " "*s 
    elseif s in trigfun
      if opts.trigfun == "deg"
        s*"(", s*"d("
      else
        s*"(", s*"("
      end
    elseif s in genfun
      s*"(", s*"("
    else
      s, s
    end
    
    text.pub *= sp
    push!(text.plens, length(sp))
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
      text.pub, text.inner = if isinteger(res) && length(resint)≤opts.displim
        resint, resint
      else
        round(res, sigdigits=opts.sigdigits) |> string, res |> string
      end
      text.plens = [length(text.pub)]
      text.ilens = [length(text.inner)]

      set_gtk_property!(display, :label, text.pub)
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
      (0==length(pij)) && continue
      di,dj = get(btn_size, pij, (0,0))
      btn_real[j:j+dj,i:i+di] = mkbtn(pij)
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
