-- karplus_rings

local cs = require 'controlspec'

local karplus_rings = {}

function karplus_rings.params()
  params:add {
    type = 'control',
    id = 'amp',
    name = 'amp',
    controlspec = cs.new(0, 1, 'lin', 0, 0.75, ''),
    action = engine.amp
  }

  params:add {
    type = 'control',
    id = 'damping',
    name = 'damping',
    controlspec = cs.new(0.1, 10, 'lin', 0, 3.6, 's'),
    action = engine.decay
  }

  params:add {
    type = 'control',
    id = 'brightness',
    name = 'brightness',
    controlspec = cs.new(0, 1, 'lin', 0, 0.11, ''),
    action = engine.coef
  }

  params:add {
    type = 'control',
    id = 'lpf_freq',
    name = 'lpf_freq',
    controlspec = cs.new(100, 10000, 'lin', 0, 3600, ''),
    action = engine.lpf_freq
  }

  params:add {
    type = 'control',
    id = 'lpf_gain',
    name = 'lpf_gain',
    controlspec = cs.new(0, 3.2, 'lin', 0, 0.5, ''),
    action = engine.lpf_gain
  }

  params:add {
    type = 'control',
    id = 'bpf_freq',
    name = 'bpf_freq',
    controlspec = cs.new(100, 9000, 'lin', 0, 1200, ''),
    action = engine.bpf_freq
  }

  params:add {
    type = 'control',
    id = 'bpf_res',
    name = 'bpf_res',
    controlspec = cs.new(0.05, 2.5, 'lin', 0, 0.5, ''),
    action = engine.bpf_res
  }
end

return karplus_rings
