N = 256              -- count of samples
dt = (60/127) / 24 -- target tick interval
dt_buf = {}        -- buffer of sampled tick times

-- alias for the norns `time()` function
now = util.time


function on_complete()
   print('complete.')
   local str = 'dt = [ '
  
  
   for i=1,N do
      str = str.. dt_buf[i] .. ', '
   end
   str = str .. ' ]\n\n'
   str = str .. 'range  = max(dt) - min(dt) \n'
   str = str .. 'stddev = std(dt) \n'
   str = str .. 'hist(dt, 64)'

   local f = io.open(norns.state.path .. 'test-time-output.m', "w")   
   if f ~= nil then
      io.output(f)
      io.write(str)
      io.close(f)
      print('wrote output file')
   else
      print('failed to open output file.')
   end

   print('done.')
end


function init()
   -- pre-allocate sample buffer
   for i=1,N do dt_buf[i] = 0 end
   print('target dt: '..dt)
   
   t0 = now()
   
   m = metro.init()
   m.event = function(i)
      t = now()
      dt_buf[i] = t - t0
      t0 = t      
      if i == N then
	 on_complete()
      end
   end
   
   m.time = dt
   m.count = N
      print('running...')
   m:start()   
end

