#!/usr/bin/ruby

fn1 = ARGV.shift
vec = Array.new
File.open(fn1).each do |line|
  a = line.chomp.split
  next if a[-1].to_i < 10
  vec << a
end

vec.each do |v|
  print "\t", v[0]
end
puts

file = ARGV.shift
  File.open(file).each("///\n") do |entry|
    id = ""
    sta = nil
    sta2 = nil
    type = nil
    freq = Hash.new
    entry.split("\n").each do |line|
      sta = line.chomp.split[0] if line =~ /^\S/
      sta2 = line.chomp.split[0] if line =~ /^\s\s\S/
      if sta == "ENTRY"
        id = line.chomp.split[1]
      elsif line =~ /\/\/\//
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
    #p freq
    print id
    vec.each do |v|
      print "\t"
      if freq[[v[1], v[2]]]
        print freq[[v[1], v[2]]]
      else
        print 0
      end
    end
    puts
  end


