#!/bin/sh
#by max.lim林炳忠 2013-12-17
if [ $# -lt 2 ]; then
	echo "usage:"
	echo "$0 filename1 filename2..."
	exit 2
fi

prefix=mr_

#cut last 1 bytes of the first file
fnFst=$1
sizeFnFst=`du -b $fnFst|awk '{print $1}'`
dd if=$fnFst of=${prefix}${fnFst} bs=1 skip=0 count=$(($sizeFnFst-1))

#cut head 9 bytes of the last file 
fnLst=${!#}
sizeFnLst=`du -b $fnLst|awk '{print $1}'`
dd if=$fnLst of=${prefix}${fnLst} bs=9 skip=1 count=$(($sizeFnLst/9+($sizeFnLst%9>0?1:0)))

for fn in $@
do
	if [[ $fn == $fnFst || $fn == $fnLst ]]; then
		continue;
	fi
	sizeFn=`du -b $fn|awk '{print $1}'`
	dd if=$fn of=${prefix}${fn} bs=1 skip=9 count=$(($sizeFn-10))
	cat ${prefix}${fn} >> ${prefix}${fnFst}
done

cat ${prefix}${fnLst} >> ${prefix}${fnFst}
mv ${prefix}${fnFst} new.rdb

for fn in $@
do
	rm -rf ${prefix}${fn}
done
