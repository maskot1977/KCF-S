How to generate KCF-S integer vectors from molfile.
This version 1.0 produces 56779-dimensional integer vectors.

*===== Step 1: From molfile (or SDF) to KCF =====*
There are two ways to generate KCF from molfile or SDF.

1-1. KCFCO
http://www.genome.jp/en/gn_ftp.html

1-2. mol2kcf
http://www.genome.jp/tools/gn_tools_api.html

*===== Step 2: From KCF to KCF-S =====*
ruby makekcfs.rb kcf-file(s) > kcfs-file

** makekcfs.rb accepts more than one kcf-files

*===== Step 3: From KCF-S to KCF-S vector =====*
ruby makekcfsd.rb kcfs2count_v1.0.txt kcfs-file > kcfsd-file

** The meanings of the KCF-S substructures are described in kcfs2count_v1.0.txt

*===== optional =====*
In case you want to define your own substructutres,
ruby kcfs2count.rb kcfs-file > count_file
count_file can be used instead of kcfs2count_v1.0.txt
However, this option is not recommended
because it would cause the confusion of IDs.

