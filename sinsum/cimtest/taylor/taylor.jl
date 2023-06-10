using CImGui
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL

using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui: ImVec2, ImVec4, IM_COL32, ImS32, ImU32, ImS64, ImU64

using Parameters # for with_kw



@with_kw mutable struct APAR
  fname::String = ""
  wsize::Int = -1
end


@with_kw mutable struct PAR
  par0::APAR = APAR()
  par1::APAR = APAR()
  raw::Array{Float64} = []
  proc::Array{Float64} = []
  onrender::Bool = false
end


let 

  flist = filter!(x->endswith(x,"txt"),readdir("data/"))
  par = PAR()

  function taylor()
    p0 = par.par0
    p1 = par.par1
    newfile = 
    if (p0.fname != p1.fname)
      p0.fname = p1.fname
      open("data/"*p1.fname) do io
        par.raw = parse.(Float64, read(io, String)|>split)
      end
    end
    if (p0.wsize != p1.wsize)
      p0.wsize = p1.wsize
    end
  end

  
  function mcimgui(;width = 1024, height = 768, title::AbstractString = "Taylor", hotloading = false)

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
          par.onrender = true
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
        par.onrender = false
        @error "Error in renderloop!" exception=e
        Base.show_backtrace(stderr, catch_backtrace())
      finally
        par.onrender = false
        ImGui_ImplOpenGL3_Shutdown()
        ImGui_ImplGlfw_Shutdown()
        CImGui.DestroyContext(ctx)
        GLFW.DestroyWindow(window)
      end
    end


    render
  end # mcimgui


  function mui()

    function ui()
      # simple selection popup
      # (If you want to show the current selection inside the Button itself, 
      # you may want to build a string using the "###" operator to preserve a constant ID with a variable label)

      CImGui.Begin("Data selection")

        # CImGui.Text("Selected: ") 
        # CImGui.SameLine()
        # CImGui.TextUnformatted("" == upar.fname ? "<None>" : apar.fname)
        # CImGui.Separator()

        for f in flist
          CImGui.Selectable(f, par.par1.fname==f) && (par.par1.fname = f;)
          #CImGui.Selectable(f) && (upar.fname = f;)
        end

      CImGui.End()

      if "" != par.par1.fname
        CImGui.Begin("Raw data")
          taylor()
          cmax = maximum(abs.(par.raw))
          CImGui.PlotLines("", Float32.(par.raw), Int32(length(par.raw)), 0, "", -cmax, cmax, ImVec2(0,200)) ;
        CImGui.End()
      end



      # if "" != par.par1.fname
      #   CImGui.Begin("Set parameters")
      #   CImGui.End()
      # end

      # if 0<par.par1.wsize
      #   CImGui.Begin("Plot and error")
      #   CImGui.End()
      # end
    end


    update()=taylor()
    

    function loop()
      @async while true==par.onrender
        update() 
        yield()
      end
    end

    ui, loop
  end


  function start()
    render = mcimgui()

    ui, loop = mui()
    render(ui)
    loop()
  end

  start, par
end