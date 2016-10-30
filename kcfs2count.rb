#!/usr/bin/ruby
# usage : ruby kcfs2count.rb kgcpd_kcfs.txt > kcfs2count.txt

freq = Hash.new
ARGV.each do |file|
  File.open(file).each("///\n") do |entry|
    sta = nil
	sta2 = nil
	type = nil
    entry.split("\n").each do |line|
	  sta = line.chomp.split[0] if line =~ /^\S/
	  sta2 = line.chomp.split[0] if line =~ /^\s\s\S/
      #if sta == "ENTRY"
	  #elsif sta == "SUBSTR" && sta2 
	  if line =~ /\/\/\//
	  elsif sta2 
	   # puts line
        a = line[12..-1].chomp.split
	    type = sta2
		next unless a[1]
	    num = a[1].scan(/\d+/)[0].to_i
	    str = a[0]
	    next unless str
		#puts line
		#p [str, num]
        replace1 = Hash.new
    	replace2 = Hash.new
    	str.scan(/[A-Z][0-9]*[a-z]*/).each do |kegatm|
    	  replace1[kegatm] = kegatm[0..0]
    	  replace2[kegatm] = kegatm[0..1]
        end
        str1 = str.clone
    	replace1.each do |k, v|
    	  str1 = str1.gsub(k, v)
        end
        str2 = str.clone
    	replace2.each do |k, v|
    	  str2 = str2.gsub(k, v)
        end
    	#p [type, str, str2, str1]
    	freq[[type, str]] ||= 0
    	freq[[type, str]] += num.to_i
    	freq[[type, str2]] ||= 0
    	freq[[type, str2]] += num.to_i
    	freq[[type, str1]] ||= 0
    	freq[[type, str1]] += num.to_i
      end
	end
  end
end

array = Array.new
freq.each do |k,v|
  array << [0 - v, k]
end
array.sort.each do |v, k|
  puts [k, 0 - v].join("\t") if v < -1
end
