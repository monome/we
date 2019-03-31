-- fourwaves example
-- softcut sample player
--
-- K2 make low note
-- K3 make high note

a = include('lib/fourwaves')

m = metro.init()

init = function()
  a.init()
end

key = function(n,z)
  if z==1 and n==3 then
    a.note(math.random(24)-6)
    redraw()
  elseif z==1 and n==2 then
    a.note(math.random(24)-18)
    redraw()
  end
end

redraw = function()
  screen.clear()
  screen.aa(1)
  screen.line_width(0.8)
  screen.move(64,32)
  screen.line_rel(math.random(20),math.random(20)-10)
  screen.line_rel(math.random(20),math.random(20)-10)
  screen.line_rel(math.random(20),math.random(20)-10)
  screen.move(64,32)
  screen.line_rel(-math.random(20),math.random(20)-10)
  screen.line_rel(-math.random(20),math.random(20)-10)
  screen.line_rel(-math.random(20),math.random(20)-10)
  screen.stroke()
  screen.update()
end



