#!/usr/bin/ruby
# usage : ruby kcfs2count.rb pd_kcfs.txt > kcfs2count.txt

freq = Hash.new
ARGV.each do |file|
  File.open(file).each("///\n") do |entry|
    sta = nil
    sta2 = nil
    type = nil
    entry.split("\n").each do |line|
      sta = line.chomp.split[0] if line =~ /^\S/
      sta2 = line.chomp.split[0] if line =~ /^\s\s\S/
      if line =~ /\/\/\//
      elsif sta2 
        a = line[12..-1].chomp.split
        type = sta2
        next unless a[1]
        num = a[1].scan(/\d+/)[0].to_i
        str = a[0]
        next unless str
        replace1 = Hash.new
    	replace2 = Hash.new
        str1 = str.gsub(/[a-z]/, "")
        str2 = str1.gsub(/\d/, "")
    	freq[[type, str]] ||= 0
    	freq[[type, str]] += num.to_i
    	freq[[type, str2]] ||= 0
    	freq[[type, str2]] += num.to_i
    	freq[[type, str1]] ||= 0
    	freq[[type, str1]] += num.to_i
        #p [type, str, str1, str2]
      end
    end
  end
end


array = Array.new
freq.each do |k,v|
  array << [0 - v, k]
  #p [0 - v, k]
end

index = 0
array.sort.each do |v, k|
  #next if v > -1
  index += 1
  num = index.to_s
  while num.size < 8
    num = "0" + num
  end
  num = "S" + num + k[0][0..0]
  puts [num, k, 0 - v].join("\t") #if v < -1
end
