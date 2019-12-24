-- softcut: buffer read/write test
--
-- see REPL output

file = _path.dust.."audio/dont_explain_48k.wav"
ch, dur, sr = audio.file_info(file)
d = dur / sr

print(file, ch, d, sr)

sc = softcut

print("loading (stereo)...")
sc.buffer_read_stereo(file, 0, 0, -1)

sc.buffer_write_stereo(file..".copy.wav", 0, d)
sc.buffer_write_mono(file..".L.wav", 0, d, 1)
sc.buffer_write_mono(file..".R.wav", 0, d, 2)

sc.buffer(1, 1)
sc.pan(1, -1)

sc.buffer(2, 2)
sc.pan(2, 1)

for i=1,2 do
   sc.level(i, 1)
   sc.loop(i, 1)
   sc.loop_start(i,0)
   sc.loop_end(i, d - 1.0)
   
   sc.play(i, 1)
   sc.rec(i, 0)
   sc.rate(i, 1)
   
   sc.position(i, 0)
   sc.enable(i, 1)
end

function key(n,z)
   if z == 0 then return end
   if n == 2 then      
      print("loading (mono, reversed channels)...")
      sc.buffer_read_mono(file, 0, 0, -1, 1, 2)
      sc.buffer_read_mono(file, 0, 0, -1, 2, 1)      
   end
   if n == 3 then
      print("reading back L, R mono output...")
      sc.buffer_read_mono(file..".L.wav", 0, 0, -1, 1, 1)
      sc.buffer_read_mono(file..".R.wav", 0, 0, -1, 2, 2)
   end
   
end
