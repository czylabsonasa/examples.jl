val = Dict(
  "one"=>1,
  "two"=>2,
  "three"=>3,
  "four"=>4,
  "five"=>5,
  "six"=>6,
  "seven"=>7,
  "eight"=>8,
  "nine"=>9,
  "1"=>1,
  "2"=>2,
  "3"=>3,
  "4"=>4,
  "5"=>5,
  "6"=>6,
  "7"=>7,
  "8"=>8,
  "9"=>9,
)

what = r"(one|two|three|four|five|six|seven|eight|nine|1|2|3|4|5|6|7|8|9)"

function mysolve(fin, fout)
  s = 0
  for line in readlines(fin)
    ms = [0,0]
    ms1 = true
    for m in eachmatch(what, line, overlap = true)
      if ms1
        ms[1]=ms[2]=val[m.match]
        ms1 = false
      else
        ms[2]=val[m.match]
      end
    end
    #println(stderr, ms)
    s += 10*ms[1]+ms[2]
  end

  println(fout, s)
end




if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end