# hfs-recovery
Automatically exported from code.google.com/p/hfs-recovery

# Introduction

How to rescue your disk

## Make a image of your disk

Use ddrescue http://www.gnu.org/software/ddrescue/ddrescue.html

    $ ddrescue /dev/sdb2 macimage logfile

## Try to repair

Try some tools to repair. Disk Warrior, and others.

## Find the blocks you need

If the repair tools doesnt work, you probably are missing the Volume header. Data as blocksize, and the location of the catalogFile are data that is difficult to recreate. You will have to find these manually. The catalogFile is separeted in several blocks. This will make the rescue harder.

## Find catalogFile

Search for files on the diskimage. Easiest is probably to use strings. `$ strings -e b macimage`

To use this find where these files are located on the disk. Use hexedit. `$ hexedit macimage CTRL-S` then enter the file you are looking for big-endian. Use 00xx00xx for the filename.

### Find head of catalogFile

If you for instance searched for Resources, and you find the file like this: 

    00D1B150 00 03 00 00 00 00 01 0B 00 09 00 52 00 65 00 73 ...........R.e.s 
    00D1B160 00 6F 00 75 00 72 00 63 00 65 00 73 00 16 00 00 .o.u.r.c.e.s....`

You can then backtrack, to find the head of this node. The leafNodes have a fingerprint.

`00D1B000 00 00 00 0F 00 00 00 0E FF 01 00 32 00 00 00 06 ...........2....`

The first 4 bytes is next node. The next 4 bytes is previous node. The FF 01 is leafNode. Then 00 32 means 32 records in this node. 00 00 is reserved, and is always 0 in my experience.

When you have the offset of the leafNode, it is time to dump it, and find the nodeNumber, the start of this extent, number of blocks in this extent, nodeSize and blockSize.

### Find rest of catalogFile

Having the last file you got out of the catalogFile, you can compare this to the files listed from strings. Find a file that you have not got out, and search for it in hexedit. Use this to find the offset that this extent has, and save that.

