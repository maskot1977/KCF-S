
program = ARGV.shift
indir = ARGV.shift
outdir = ARGV.shift
raise unless outdir
unless File.exist?(program)
  puts  "#{program} does not exist."
  raise
end
system "mkdir #{outdir}"
idx = 0
Dir.foreach(indir) do |item|
  next if item =~ /^\./
  idx += 1
  infile = "#{indir}/#{item}"
  outfile = "#{outdir}/#{item}".sub("sdf", "kcf")
  str =  "#{program} #{infile} #{outfile} 2>/dev/null >/dev/null"
  system str
  if (idx%10000) == 0
    puts "#{idx} files processed..."
  end
end
puts "#{idx} files processed. Done."
