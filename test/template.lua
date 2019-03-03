-- TEMPLATE 1.0.0
-- http://monome.org
-- 
-- a code example showing some
-- basic functions and how to
-- use them.
--
-- see additional documentation
-- at monome.org/docs/norns/

-- specify dsp engine to load:
engine.name = 'TestSine'

-- make a variable
local t = 0
-- make an array for storing
local numbers = {0, 0, 0, 0, 0, 0, 0}
-- make a var, led brightness for grid
local level = 5

-- set up a metro
local c = metro.init()
-- count forever
c.count = -1
-- count interval to 1 second
c.time = 1
-- callback function on each count
c.event = function(stage)
  t = t + 1
  redraw()
end

-- init function
function init()
  -- print to command line
  print("template!")
  -- show engine commands available
  engine.list_commands()
  -- set engine params
  engine.hz(200)
  -- start timer
  c:start()
end

-- encoder function
function enc(n, delta)
  numbers[n] = numbers[n] + delta
  -- redraw screen
  redraw()
end

-- key function
function key(n, z)
  numbers[n+3] = z
  -- redraw screen
  redraw()
end

-- screen redraw function
function redraw()
  -- screen: turn on anti-alias
  screen.aa(1)
  screen.line_width(1.0)
  -- clear screen
  screen.clear()
  -- set pixel brightness (0-15)
  screen.level(15)

  for i=1, 6 do
    -- move cursor
    screen.move(0, i*8-1)
    -- draw text
    screen.text("> "..numbers[i])
  end

  -- show timer
  screen.move(0, 63)
  screen.text("> "..t)

  -- refresh screen
  screen.update()
end

-- called on script quit, release memory
function cleanup ()
  numbers = nil
end
