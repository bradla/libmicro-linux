#!/bin/sh
# fscmp.sh <target-dir> <label>  -- run the fs-sensitive libMicro benchmarks
# with their data file on <target-dir>, print "name label usecs errors".
D="$1"; L="$2"
W="$D/lm.$$"; DIR1="$W/dir1/a/b/c"
mkdir -p "$DIR1" 2>/dev/null
F="$W/data"
dd if=/dev/zero of="$F" bs=1024k count=10 2>/dev/null
B=/home/brad/libMicro-linux/bin
O="-E -C 100 -L -S -W"
row() { awk -v L="$L" '/^[a-z][a-zA-Z0-9_]+[ \t]+[0-9]+[ \t]+[0-9]+[ \t]+[0-9]/{print $1" "L" "$4" "$6}'; }
{
$B/open     $O -N open       -B 256           -f "$F"
$B/close    $O -N close      -B 32            -f "$F"
$B/stat     $O -N stat       -I 1000          -f "$F"
$B/fcntl    $O -N fcntl      -I 100           -f "$F"
$B/lseek    $O -N lseek      -s 8k -I 50      -f "$F"
$B/read     $O -N read_1k    -s 1k            -f "$F"
$B/read     $O -N read_10k   -s 10k           -f "$F"
$B/read     $O -N read_100k  -s 100k          -f "$F"
$B/write    $O -N write_1k   -s 1k            -f "$F"
$B/write    $O -N write_10k  -s 10k           -f "$F"
$B/write    $O -N write_100k -s 100k          -f "$F"
$B/pread    $O -N pread_10k  -s 10k  -I 1000  -f "$F"
$B/pwrite   $O -N pwrite_10k -s 10k  -I 1000  -f "$F"
$B/writev   $O -N writev_10k -s 10k           -f "$F"
$B/mmap     $O -N mmap_128k  -l 128k -I 1000  -f "$F"
$B/msync    $O -N msync_128k -l 128k -I 100   -f "$F"
$B/realpath $O -N realpath   -I 3000          -f "$DIR1"
} 2>/dev/null | row
rm -rf "$W"
