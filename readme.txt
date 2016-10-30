How to generate KCF-S integer vectors from molfile

Step 1: From molfile to KCF
Please refer to the GenomeNet webpage 
http://www.genome.jp/tools/gn_tools_api.html

Step 2: From KCF to KCF-S
ruby makekcfs.rb kcf-file > kcfs-file

Step 3: Generate columns 
ruby kcfs2count.rb kcfs-file > count-file

Step 4: From KCF-S to KCF-S vector
ruby makekcfsd.rb count-file kcfs-file > kcfsd-file
