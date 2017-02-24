
sdffile = ARGV.shift
dire = ARGV.shift
raise unless dire
system "mkdir #{dire}"
idx = 0
File.open(sdffile).each("$$$$\n") do |entry|
  idx += 1
  outfile = "#{dire}/#{idx}.sdf"
  fout = open(outfile, "w")
  fout.puts entry
  fout.close
  if (idx%10000) == 0
    puts "#{idx} files processed..."
  end
end
puts "#{idx} files processed. Done."
