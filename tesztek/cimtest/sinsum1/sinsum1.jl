using CImGui
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL

using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui: ImVec2, ImVec4, IM_COL32, ImS32, ImU32, ImS64, ImU64


mutable struct WS # state of rendering
  onrender::Bool
end


function mcimgui(;width = 1024, height = 768, title::AbstractString = "Demo", hotloading = false)

  state = WS(false)

  error_callback(err::GLFW.GLFWError) = @error "GLFW ERROR: code $(err.code) msg: $(err.description)"

  window, ctx = begin
    glsl_version = if Sys.isapple()
      # OpenGL 3.2 + GLSL 150
      GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
      GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 2)
      GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
      GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # required on Mac
      150
    else
      # OpenGL 3.0 + GLSL 130
      GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
      GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 0)
      # GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
      # GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # 3.0+ only
      130
    end
    # setup GLFW error callback
    GLFW.SetErrorCallback(error_callback)

    # create window
    window = GLFW.CreateWindow(width, height, title)
    @assert window != C_NULL
    GLFW.MakeContextCurrent(window)
    GLFW.SwapInterval(1)  # enable vsync

    # setup Dear ImGui context
    ctx = CImGui.CreateContext()

    # setup Dear ImGui style
    CImGui.StyleColorsDark()
    # CImGui.StyleColorsClassic()
    # CImGui.StyleColorsLight()

    # setup Platform/Renderer bindings
    ImGui_ImplGlfw_InitForOpenGL(window, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    window, ctx
  end

  function render(ui)
    GC.@preserve window ctx @async try
      while !GLFW.WindowShouldClose(window)
        state.onrender = true
        GLFW.PollEvents()
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        hotloading ? Base.invokelatest(ui) : ui() ###

        CImGui.Render()
        GLFW.MakeContextCurrent(window)
        display_w, display_h = GLFW.GetFramebufferSize(window)
        glViewport(0, 0, display_w, display_h)
        glClearColor(0.2, 0.2, 0.2, 1)
        glClear(GL_COLOR_BUFFER_BIT)
        ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())

        GLFW.MakeContextCurrent(window)
        GLFW.SwapBuffers(window)
        yield()
      end
    catch e
      state.onrender = false
      @error "Error in renderloop!" exception=e
      Base.show_backtrace(stderr, catch_backtrace())
    finally
      state.onrender = false
      ImGui_ImplOpenGL3_Shutdown()
      ImGui_ImplGlfw_Shutdown()
      CImGui.DestroyContext(ctx)
      GLFW.DestroyWindow(window)
    end
  end


  render, state
end # mcimgui


mutable struct mobj
  fun::Function
  val::Array{Float64}
  strength::Float32
  dend::Float32
  step::Float32
  go_flag::Bool
  name::String
end


function mui()
  velo = Int32(10)

  step = 0.001
  dend = 2pi
  dom = collect(0:step:dend)
  ldom = length(dom)
  msum = similar(dom)

  fun1 = x->sin(x)
  obj1 = mobj(fun1, fun1.(dom), 1.0, dend, step, true, "sin(x)")

  fun2 = x->sin(2.0*x)
  obj2 = mobj(fun2, fun2.(dom), 1.0, dend, step, true, "sin(2x)")
  
  fun3 = x->sin(4.0*x)
  obj3 = mobj(fun3, fun3.(dom), 1.0, dend, step, true, "sin(4x)")

  fun4 = x->sin(8.0*x)
  obj4 = mobj(fun4, fun4.(dom), 1.0, dend, step, true, "sin(8x)")


  objs = [obj1,obj2,obj3,obj4]

  # println(obj1.val |> length)
  # println(obj2.val |> length)

  
  function ui()
    CImGui.Begin("Controls")
    @c CImGui.SliderInt("velocity", &velo, 0, 30) ;
    for obj in objs
      @c CImGui.InputFloat(obj.name, &obj.strength, 0.01, 1.0, "%.3f") ;
    end

    # @c CImGui.InputFloat(obj1.name, &obj1.strength, 0.01, 1.0, "%.3f") ;
    # @c CImGui.InputFloat(obj2.name, &obj2.strength, 0.01, 1.0, "%.3f") ;
    # @c CImGui.InputFloat(obj3.name, &obj3.strength, 0.01, 1.0, "%.3f") ;
    # @c CImGui.InputFloat(obj4.name, &obj4.strength, 0.01, 1.0, "%.3f") ;
    CImGui.End()


    CImGui.Begin("Sum") ;
    cmax = sum( abs.([obj1.strength,obj2.strength,obj3.strength,obj4.strength]))
    CImGui.PlotLines("sum", Cfloat.(msum), ldom, 0, "", -cmax,cmax,ImVec2(0,200)) ;

    CImGui.End()
  end


  update(obj)=if obj.strength != 0.0
    v = 10 * velo #
    obj.val[1:end-v] .= obj.val[v+1:end];
    step = obj.step
    dend = obj.dend
    obj.dend = dend+v*step
    obj.val[end-v+1:end] .= obj.fun.(range(dend+step,obj.dend,length=v))
    1
  else
    0
  end


  update()=begin
    msum .= 0.0
    for obj in objs
      update(obj)>0 && (msum .+= obj.strength*obj.val)
    end
      # msum .+= obj1.strength*obj1.val
      # msum .+= obj2.strength*obj2.val
      # msum .+= obj3.strength*obj3.val
      # msum .+= obj4.strength*obj4.val
  end
  

  function loop(ws)
    @async while ws.onrender == true
        update() 
        yield()
        #sleep(0.01)
    end
  end

  ui, loop
end


function startui(mkui)
  render, ws = mcimgui()

  ui, loop = mkui()
  render(ui)
  loop(ws)
end
