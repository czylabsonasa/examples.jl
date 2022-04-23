# master
lang2details=Dict(
  "py" => (pre="", cmd="python", ext=".py"),
  "pypy"   => (pre="", cmd="pypy",   ext=".py"),
  "jl"  => (pre="", cmd="julia",  ext=".jl")
)


function executer(desc)
  lang=desc["lang"]
  problem=desc["problem"]
  task=desc["task"]
  dts=lang2details[lang]
  cmd=dts.cmd
  ext=dts.ext

  user="user"*ext
  problem=problem*"/"
  cp(user,problem*user,force=true)
  cd(problem)
  run(`$(cmd) $(user) $(task)`)
  rm(user)
end

desc=Dict{String,String}()
for opt in ARGS
  k,v=split(opt,"=")
  desc[k]=v
end
executer(desc)
