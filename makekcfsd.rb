#!/usr/bin/ruby
# usage: ruby make_kcfs_descriptors.rb kcfs2count.txt jul11-9.2.txt > kegg_kcfsd.txt

fn1 = ARGV.shift

labels = Array.new
File.open(fn1).each do |line|
  a = line.chomp.split("\t")
  labels << [a[0], a[1]].join("_")
end
puts labels.join("\t")
#labels.each do |label|
#  print "\t", label
#end
#puts

ARGV.each do |file|
  File.open(file).each("///\n") do |entry|
    freq = Hash.new
	cpd = nil
	sta = nil
	sta2 = nil
	type = nil
	entry.split("\n").each do |line|
	  sta = line.chomp.split[0] if line =~ /^\S/
	  sta2 = line.chomp.split[0] if line =~ /^\s\s\S/
	  if sta == "ENTRY"
	    cpd = line.chomp.split[1]
		sta = nil
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
        freq[[type, str].join("_")] ||= 0 
        freq[[type, str].join("_")] += num.to_i 
        freq[[type, str2].join("_")] ||= 0 
        freq[[type, str2].join("_")] += num.to_i 
        freq[[type, str1].join("_")] ||= 0 
        freq[[type, str1].join("_")] += num.to_i 
	  end
    end
	next unless cpd
	print cpd
    labels.each do |label|
	  print "\t"
	  if freq[label]
        print freq[label]
      else
	    print 0
      end
    end
	puts
  end
end

