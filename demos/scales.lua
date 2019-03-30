-- Scales Demo
--
-- Example scale and chord
-- generation using MusicUtil.
-- 
-- E1 : Tempo
-- E2 : Root note
-- E3 : Scale or chord
-- K2 : Play/Pause
-- K3 : Mode
--
-- v1.1.0 Mark Eats
-- 

function unrequire(name)
  package.loaded[name] = nil
  _G[name] = nil
end
unrequire("musicutil")

local MusicUtil = require "musicutil"

local mode = 1
local root_note = 48
local scale_type = 1
local chord_type = 1

local notes = {}
local note_names = {}
local length = 0
local SCALES_LEN = #MusicUtil.SCALES
local CHORDS_LEN = #MusicUtil.CHORDS

local tempo = 90
local step = 1
local step_increment = 1
local step_metro

engine.name = "PolyPerc"


local function init_scale()
  notes = MusicUtil.generate_scale(root_note, scale_type, 1)
end

local function init_chord()
  notes = MusicUtil.generate_chord(root_note, chord_type)
  step = 0
  step_increment = 1
end

local function update_notes()
  if mode == 1 then
    init_scale()
  else
    init_chord()
  end
  note_names = MusicUtil.note_nums_to_names(notes)
  length = #notes
end

local function play_notes()
  if mode == 1 then
    engine.hz(MusicUtil.note_num_to_freq(notes[step]))
  else
    for i = 1, length do
      engine.hz(MusicUtil.note_num_to_freq(notes[i]))
    end
  end
end

local function advance_step()
  if mode == 1 then
    if step >= length then
      step = length
      step_increment = -1
    elseif step == 1 then
      step_increment = 1
    end
    step = step + step_increment
    play_notes()
  
  else
    step = step + step_increment
    if (step - 1) % 8 == 0 then
      play_notes()
    end
  end
  
  redraw()
end

local function start_stop_metro()
  if step_metro.is_running then
    step_metro:stop()
  else
    if mode == 1 then
      if step < 1 or step > length then step = 1 end
      play_notes()
    else
      step = 0
    end
    step_metro:start(60 / tempo / 4) --  16ths
  end
end


function init()
  
  engine.amp(0.5)
  
  update_notes()
  
  step_metro = metro.init()
  step_metro.event = advance_step
  start_stop_metro()
  
  screen.aa(1)
  redraw()
end


function enc(n, delta)

  -- ENC1 tempo
  if n == 1 then
    tempo = util.clamp(tempo + delta, 60, 200)
    step_metro.time = 60 / tempo / 4
    
  -- ENC2 root note
  elseif n == 2 then
    root_note = util.clamp(root_note + delta, 36, 84)
    update_notes()
    
  -- ENC3 scale / chord
  elseif n == 3 then
    if mode == 1 then
      scale_type = util.clamp(scale_type + delta, 1, SCALES_LEN)
    else
      chord_type = util.clamp(chord_type + delta, 1, CHORDS_LEN)
    end
    update_notes()
    
  end
  
  redraw()
  
end

function key(n, z)
  
  if z == 1 then
    
    -- KEY2 is play/pause
    if n == 2 then
      start_stop_metro()
   
    -- KEY3 is mode
    elseif n == 3 then
      mode = mode % 2 + 1
      update_notes()
    end
    
    redraw()
  
  end
end


function redraw()
  screen.clear()

  screen.level(15)
  
  -- Play/pause
  if step_metro.is_running then
    screen.move(116, 6.2)
    screen.line(123, 9.5)
    screen.line(116, 12.8)
    screen.close()
  else
    screen.rect(116, 6, 2, 7)
    screen.rect(120, 6, 2, 7)
  end
  screen.fill()
  
  -- Tempo
  screen.move(5, 12)
  screen.text(tempo .. " BPM")

  -- Mode
  local name
  screen.level(3)
  screen.move(42, 12)
  if mode == 1 then
    screen.text("Scale")
    name = MusicUtil.SCALES[scale_type].name
  else
    screen.text("Chord")
    name = MusicUtil.CHORDS[chord_type].name
  end

  -- Name
  screen.level(15)
  screen.move(5, 27)
  screen.text(MusicUtil.note_num_to_name(root_note, true) .. " " .. name)

  -- Notes
  local x, y = 5, 52
  local cols = 8
  if length > cols then
    cols =  util.round_up(length * 0.5)
    y = y - 6
  end
  for i = 1, length do
    if i == cols + 1 then x, y = 5, y + 12 end
    screen.move(x, y)
    if (mode == 1 and i == step) or (mode == 2 and (step - 1) % 8 == 0) then
      screen.level(15)
    else
      screen.level(3)
    end
    screen.text(note_names[i])
    if string.len(note_names[i]) > 1 then x = x + 16
    else x = x + 10 end
  end
   
  screen.update()
end
