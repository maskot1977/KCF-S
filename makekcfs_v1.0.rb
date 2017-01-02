#!/usr/bin/ruby

max_ringsize = 12

def bind_tree(a1, a2)
  array1 = a1.clone
  array2 = a2.clone
  while array1.size > 1
    index_of = Hash.new
    index = 0
    array1.each_with_index do |ary1, x|
      ary1.each_with_index do |str2, y|
        next if str2.class == Fixnum
        index += 1
        index_of[index] = [x,y]
      end
    end
    i = array1.size - 1
    #p [i, array1[i], array2[i]]
    add_str = "(" + array1[i][1..-1].join("-") + ")"
    x, y = index_of[array1[i][0]]
    if x && y && add_str != "()"
      #p [x, y, add_str, array1[x][y]]
      array1[x][y] += add_str
      array2[x][y] = array2[x][y].to_s + "(" + array2[i].join("-").to_s + ")"
    end
    
    new_array1 = Array.new
    new_array2 = Array.new
    array1.each_with_index do |ary1, index|
      break if index == array1.size - 1
      #p [index, ary1, array2[index]]
      new_array1 << ary1
      new_array2 << array2[index]
    end
    array1 = new_array1
    array2 = new_array2
    #break
  end
  return [array1.join("-"), array2.join("-")]
end


freq = Hash.new
ARGV.each do |file|
File.open(file).each("///\n") do |entry|
  sta = nil
  nodeh = Hash.new
  neigh = Hash.new
  bonds = Array.new
  id = nil
  top_line = ""
  entry.split("\n").each do |line|
    sta = line.chomp.split[0] if line =~ /^\S/
    if sta == "ENTRY"
      #$stderr.puts line
      top_line += line + "\n"
      top_line += "SUBSTR"
      id = line.chomp.split[1]
    elsif sta == "ATOM" && line =~ /^\s/
      a = line.chomp.split
      nodeh[a[0]] = a[1]
    elsif sta == "BOND" && line =~ /^\s/
      a = line.chomp.split
      neigh[a[1]] ||= Array.new
      neigh[a[1]] << a[2]
      neigh[a[2]] ||= Array.new
      neigh[a[2]] << a[1]
      bonds << [a[1], a[2]]
    end
  end
  #next if id != target_id if target_id 
    
  puts top_line
#=begin
  ##### atom
  freq = Hash.new
  nodeh.each do |atm, ele|
    freq[ele] ||= Array.new
    freq[ele] << atm
  end
  array = Array.new
  freq.each do |ele, ary|
    array << [0 - ary.size, ele]
  end
  index = 0
  array.sort.each do |n, ele|
    index += 1
	if index == 1
      print "  ATOM      "
	else
      print "            "
    end
	print ele, " (", 0 - n, ") ", freq[ele].join(" "), "\n"
  end

  ##### bond
  freq = Hash.new
  bonds.each do |atm1, atm2|
    ele1 = nodeh[atm1]
    ele2 = nodeh[atm2]
    if ele2 < ele1
      bond = [ele2, ele1].join("-")
      atms = [atm2, atm1].join("-")
      freq[bond] ||= Array.new
      freq[bond] << atms
    else
      bond = [ele1, ele2].join("-")
      atms = [atm1, atm2].join("-")
      freq[bond] ||= Array.new
      freq[bond] << atms
    end
  end
  array = Array.new
  freq.each do |ele, ary|
    array << [0 - ary.size, ele]
  end
  index = 0
  array.sort.each do |n, ele|
    index += 1
	if index == 1
      print "  BOND      "
	else
      print "            "
    end
	print ele, " (", 0 - n, ") ", freq[ele].join(" "), "\n"
    #puts [id, "bond", 0 - n, ele, freq[ele].join(" ")].join("\t")
  end

  ##### triplet
  freq = Hash.new
  neigh.each do |atm, neis|
    next if neis.size < 2
    for i in 0..(neis.size - 1)
      elei = nodeh[neis[i]]
      for j in 0..(neis.size - 1)
        next if i == j
        next if i > j
        elej = nodeh[neis[j]]
        #p [i, atm, j, elei, nodeh[atm], elej]
        if elei > elej
          string = [elej, nodeh[atm], elei].join("-")
          path = [neis[j], atm, neis[i]].join("-")
          freq[string] ||= Array.new
          freq[string] << path
        else
          string = [elei, nodeh[atm], elej].join("-")
          path = [neis[i], atm, neis[j]].join("-")
          freq[string] ||= Array.new
          freq[string] << path
        end
      end
    end
  end
  array = Array.new
  freq.each do |ele, ary|
    array << [0 - ary.size, ele]
  end
  index = 0
  array.sort.each do |n, ele|
    index += 1
	if index == 1
      print "  TRIPLET   "
	else
      print "            "
    end
	print ele, " (", 0 - n, ") ", freq[ele].join(" "), "\n"
  end

  ##### vicinity
  freq = Hash.new
  neigh.each do |atm, neis|
    next if neis.size < 3
    str = nodeh[atm] + "(" + neis.collect{|x| nodeh[x]}.sort.join("+") + ")"
    freq[str] ||= Array.new
    freq[str] << atm
  end
  array = Array.new
  freq.each do |ele, ary|
    array << [0 - ary.size, ele]
  end
  index = 0
  array.sort.each do |n, ele|
    index += 1
	if index == 1
      print "  VICINITY  "
	else
      print "            "
    end
	#print ele, " (", 0 - n, ") ", freq[ele].join(" "), "\n"
	print ele, " (", 0 - n, ")"
        freq[ele].each do |cpdatm|
          print " ", cpdatm, "(", neigh[cpdatm].join("+"), ")"
        end
        puts
  end

  ##### ring
  #p ["ring", Time.now]
  freq = Hash.new
  paths = Array.new
  neigh.each do |ori, neis|
    neis.each do |nei|
      paths << [nei, ori]
    end
  end

  ringh = Hash.new
  count100 = 0
  while paths.size > 0
    count100 += 1
    #break if count100 > 100
    path = paths.shift
    #p [path, path.collect{|x| nodeh[x]}]
	next if path.length > max_ringsize
    neigh[path[0]].each do |nei|

      next if nodeh[nei] =~ /C1[abcd]/
      next if nodeh[nei] =~ /C2[abcd]/
      next if nodeh[nei] =~ /C[46]/
      next if nodeh[nei] =~ /C5a/
      next if nodeh[nei] =~ /C7a/
      next if nodeh[nei] =~ /N1[abcd]/
      next if nodeh[nei] =~ /N2[abcd]/
      next if nodeh[nei] =~ /S1[abcd]/
      next if nodeh[nei] =~ /S2[abcd]/

      if path.include?(nei)
        next if path.size == 2
        next if path[path.size - 1] != nei
        #p [nei, path, path.collect{|x| nodeh[x]}]
        string_array = Array.new
        path.each do |atm|
          str = nodeh[atm].clone
#          ary = (neigh[atm] - path).collect{|x| nodeh[x]}
#          if ary.size > 0
#            str += "(" + ary.sort.join("+") + ")"
#          end
          string_array << str
        end
        key = path.sort
        ringh[key] ||= Array.new
        ringh[key] << [string_array.join("-"), path]
      else
        new_path = path.clone
        new_path.unshift(nei)
        paths << new_path
      end
    end
  end

  ringh.each do |key, val|
    val.sort.each do |a|
      freq[a[0]] ||= Array.new
      freq[a[0]] << a[1]
      break
    end
  end

  array = Array.new
  freq.each do |string, ary|
    array << [0 - ary.size, string]
  end
  index = 0
  array.sort.each do |n, string|
    index += 1
	if index == 1
      print "  RING      "
	else
      print "            "
    end
	print string, " (", 0 - n, ") ", freq[string].collect{|x| x.join("-")}.join(" "), "\n"
    #puts [id, "ring", 0 - n, string, freq[string].collect{|x| x.join("-")}.join(" ")].join("\t")
  end
  freq = Hash.new
#=end

  ##### skeleton
  #p ["skeleton", Time.now]
  hash = Hash.new
  nodeh.each do |atm, ele|
    next if ele !~ /^C/
    next unless neigh[atm]
    queue = Array.new
    neigh[atm].each do |nei|
      next if nodeh[nei] !~ /^C/
      path = [atm, nei]
      string = [ele, nodeh[nei]]
      #p [string.join("-"), path.join("-")]
      queue << [string, path]
    end

    members = Array.new
    strings = Array.new
    count100 = 0
    while queue.size > 0
      count100 += 1
      #break if count100 > 100
      string, path = queue.shift
      last = path[path.size - 1]
      members += path
      members.uniq!
	next if path.length > max_ringsize ###

      tuduki = 0
      neigh[last].each do |nei|
        next if nodeh[nei] !~ /^C/
        next if path.include?(nei)
        tuduki += 1
        new_path = path.clone
        new_string = string.clone
        new_path << nei
        new_string << nodeh[nei]
        queue << [new_string, new_path]
      end

      if tuduki == 0
        strings << [0 - path.size, string, path]
      end
    end

    index_of = Hash.new
    array = Array.new
    array2 = Array.new
    shown = Hash.new
    array3 = Array.new
    strings.sort.each do |length, string, path|
      #p [length, string, path]
      ary = Array.new
      ary2 = Array.new
      count = 0
      path.each do |atm|
        if index_of[atm]
        else
          index = index_of.keys.size + 1
          index_of[atm] = index
        end
        if shown[atm]
          ary << index_of[atm]
          #ary2 << atm
        else
          count += 1
          str = nodeh[atm]
          neibors = Array.new
          neigh[atm].each do |nei|
            next if members.include?(nei)
            neibors << nodeh[nei]
          end
#          if neibors.size > 0
#            str += "(" + neibors.sort.join("+") + ")"
#          end
          ary << str
          ary2 << atm
        end
        shown[atm] = true
      end
      ary_kai = Array.new
      ary.reverse.each do |word|
        ary_kai.unshift(word)
        break if word.class == Fixnum
      end
      next if count == 0
      array << ary_kai #.join("-")
      array2 << ary2 #.join("-")
      array3 << 0 - count
    end
    #key = members.sort
    #hash[key] ||= Array.new
    #hash[key] << [array3, array.join(":"), array2.join(":")]
    #next if array.size < 3
    #next if array[array.size - 1].size < 3

    #p [array3, array.collect{|x| x.join("-")}.join(":"), array2.collect{|x| x.join("-")}.join(":")]

    lengths = array2.collect{|x| 0 - x.size}
    string, path = bind_tree(array, array2)
    
    key = path.scan(/\d+/).collect{|x| x.to_i}.sort
    hash[key] ||= Array.new
    hash[key] << [lengths, string, path]
  end

  result_array = Array.new
  hash.each do |k, v|
    #p [k, v]
    v.sort.each do |vv|
      next if vv[0] == []
      result_array << [id, "skeleton", 1, vv[1], vv[2]]
      break
    end
  end
  stop_it = Hash.new
  if result_array.size > 1
    for i in 0..(result_array.size - 2)
      atms1 = result_array[i][4].scan(/\d+/)
      for j in (i + 1)..(result_array.size - 1)
        atms2 = result_array[j][4].scan(/\d+/)
        next if (atms1 & atms2).size == 0
        sa1 = atms1 - atms2
        sa2 = atms2 - atms1
        if sa1.size > 0 && sa2.size > 0
        elsif sa1.size > 0
          stop_it[j] = true
        else
          stop_it[i] = true
        end
      end
    end
  end
  result_array2 = Array.new
  for i in 0..(result_array.size - 1)
    unless stop_it[i]
	  result_array2 << result_array[i]
      #puts result_array[i].join("\t")
    else
      #print "#"
      #puts result_array[i].join("\t")
    end
  end
  index = 0
  result_array2.sort.each do |a|
    index += 1
	if index == 1
      print "  SKELETON  "
	else
      print "            "
    end
	print a[3], " (", a[2], ") ", a[4], "\n"
  end

  ##### inorganic
  hash = Hash.new
  nodeh.each do |atm, ele|
    next if ele =~ /^C/
    next unless neigh[atm]
    queue = Array.new
    neigh[atm].each do |nei|
      next if nodeh[nei] =~ /^C/
      path = [atm, nei]
      string = [ele, nodeh[nei]]
      #p [string.join("-"), path.join("-")]
      queue << [string, path]
    end

    members = Array.new
    strings = Array.new
    count100 = 0
    while queue.size > 0
      count100 += 1
      #break if count100 > 100
      string, path = queue.shift
      last = path[path.size - 1]
      members += path
      members.uniq!
      next if path.length > max_ringsize ###

      tuduki = 0
      neigh[last].each do |nei|
        next if nodeh[nei] =~ /^C/
        next if path.include?(nei)
        tuduki += 1
        new_path = path.clone
        new_string = string.clone
        new_path << nei
        new_string << nodeh[nei]
        queue << [new_string, new_path]
      end

      if tuduki == 0
        strings << [0 - path.size, string, path]
      end
    end

    index_of = Hash.new
    array = Array.new
    array2 = Array.new
    shown = Hash.new
    array3 = Array.new
    strings.sort.each do |length, string, path|
      #p [length, string, path]
      ary = Array.new
      ary2 = Array.new
      count = 0
      path.each do |atm|
        if index_of[atm]
        else
          index = index_of.keys.size + 1
          index_of[atm] = index
        end
        if shown[atm]
          ary << index_of[atm]
          #ary2 << atm
        else
          count += 1
          str = nodeh[atm]
          neibors = Array.new
          neigh[atm].each do |nei|
            next if members.include?(nei)
            neibors << nodeh[nei]
          end
#          if neibors.size > 0
#            str += "(" + neibors.sort.join("+") + ")"
#          end
          ary << str
          ary2 << atm
        end
        shown[atm] = true
      end
      ary_kai = Array.new
      ary.reverse.each do |word|
        ary_kai.unshift(word)
        break if word.class == Fixnum
      end
      next if count == 0
      array << ary_kai #.join("-")
      array2 << ary2 #.join("-")
      array3 << 0 - count
    end
    #key = members.sort
    #hash[key] ||= Array.new
    #hash[key] << [array3, array.join(":"), array2.join(":")]
    #next if array.size < 3
    #next if array[array.size - 1].size < 3

    #p [array3, array.collect{|x| x.join("-")}.join(":"), array2.collect{|x| x.join("-")}.join(":")]

    lengths = array2.collect{|x| 0 - x.size}
    string, path = bind_tree(array, array2)
    
    key = path.scan(/\d+/).collect{|x| x.to_i}.sort
    hash[key] ||= Array.new
    hash[key] << [lengths, string, path]
  end

  result_array = Array.new
  hash.each do |k, v|
    #p [k, v]
    v.sort.each do |vv|
      next if vv[0] == []
      result_array << [id, "inorganic", 1, vv[1], vv[2]]
      break
    end
  end
  stop_it = Hash.new
  if result_array.size > 1
    for i in 0..(result_array.size - 2)
      atms1 = result_array[i][4].scan(/\d+/)
      for j in (i + 1)..(result_array.size - 1)
        atms2 = result_array[j][4].scan(/\d+/)
        next if (atms1 & atms2).size == 0
        sa1 = atms1 - atms2
        sa2 = atms2 - atms1
        if sa1.size > 0 && sa2.size > 0
        elsif sa1.size > 0
          stop_it[j] = true
        else
          stop_it[i] = true
        end
      end
    end
  end
  result_array2 = Array.new
  for i in 0..(result_array.size - 1)
    unless stop_it[i]
      #puts result_array[i].join("\t")
	  result_array2 << result_array[i]
    else
      #print "#"
      #puts result_array[i].join("\t")
    end
  end
  index = 0
  result_array2.sort.each do |a|
    index += 1
	if index == 1
      print "  INORGANIC "
	else
      print "            "
    end
	print a[3], " (", a[2], ") ", a[4], "\n"
  end

  ### STRING4
  string_length = 4
  strings_resulth = Hash.new
  neigh.each do |snode, neis|
	queue = Array.new
	neis.each do |nei|
	  path = [nei]
	  queue << path
	end
	while queue.size > 0
	  curr_path = queue.shift
	  next if curr_path.uniq.size != curr_path.size
	  if curr_path.size == string_length
	    curr_path_kgatm = curr_path.collect{|x| nodeh[x]}
		curr_path2 = curr_path.reverse
		curr_path2_kgatm = curr_path_kgatm.reverse
		curr_path_kgatm = curr_path_kgatm.join("-")
		curr_path2_kgatm = curr_path2_kgatm.join("-")
		if curr_path_kgatm < curr_path2_kgatm
		  strings_resulth[curr_path_kgatm] ||= Array.new
		  strings_resulth[curr_path_kgatm] << curr_path unless strings_resulth[curr_path_kgatm].include?(curr_path)
		else
		  strings_resulth[curr_path2_kgatm] ||= Array.new
		  strings_resulth[curr_path2_kgatm] << curr_path2 unless strings_resulth[curr_path2_kgatm].include?(curr_path2)
		end
	  elsif curr_path.size < string_length
		neigh[curr_path[-1]] && neigh[curr_path[-1]].each do |mei|
		  next if curr_path.include?(mei)
	      new_path = curr_path.clone
		  new_path << mei
		  queue << new_path
		end
	  end
    end
  end
  strings_results = Array.new
  strings_resulth.each do |key, val|
    strings_results << [0 - val.uniq.size, key]
  end
#  index = 0
#  strings_results.sort.each do |n, key|
#    index += 1
#	if index == 1
#	  print "  STRING#{string_length}   "
#	else
#	  print "            "
#	end
#    print key, " (", 0 - n, ") ", strings_resulth[key].collect{|x| x.join("-")}.join(" "), "\n"
#  end
  puts "///"

  #if id == target_id
  #  break
  #end
end
end
