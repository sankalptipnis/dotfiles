#!/usr/bin/env bash

COLOR tty

TERM alacritty
TERM alacritty-direct
TERM ansi
TERM *color*
TERM con[0-9]*x[0-9]*
TERM cons25
TERM console
TERM cygwin
TERM dtterm
TERM dvtm
TERM dvtm-256color
TERM Eterm
TERM eterm-color
TERM fbterm
TERM gnome
TERM gnome-256color
TERM hurd
TERM jfbterm
TERM konsole
TERM konsole-256color
TERM kterm
TERM linux
TERM linux-c
TERM mlterm
TERM putty
TERM putty-256color
TERM rxvt*
TERM rxvt-unicode
TERM rxvt-256color
TERM rxvt-unicode256
TERM screen*
TERM screen-256color
TERM st
TERM st-256color
TERM terminator
TERM tmux*
TERM tmux-256color
TERM vt100
TERM xterm*
TERM xterm-color
TERM xterm-88color
TERM xterm-256color
TERM xterm-kitty

#+-----------------+
#+ Global Defaults +
#+-----------------+
NORMAL 00 						# no: default
RESET 0 						# rs: reset to NORMAL

FILE 00 					    # fi: regular file	
DIR 01;91						# di: directory
LINK 01;96						# ln: symbolic link
MULTIHARDLINK 01;96 			# mh: hard link

FIFO 1;93;44					# pi: pipe
SOCK 00;32						# so: socket
DOOR 1;92;44					# do: door
BLK 01;97;44 					# bd: block device driver
CHR 01;97;44 					# cd: character device driver

ORPHAN 01;97;41 				# or: symlink to nonexistent file, or non-stat'able file
# MISSING 01;97;41				# mi: non-existent file pointed to by a symbolic link
MISSING 01;91			    	# mi: non-existent file pointed to by a symbolic link (also used in autocomplete for brew commands!)

EXEC 01;92 						# ex: executable

SETUID 01;97 					# su: file that is setuid (u+s)
SETGID 01;97					# sg: file that is setgid (g+s)
CAPABILITY 01;37 				# ca: file with capability

STICKY_OTHER_WRITABLE 1;92;100  # tw: dir that is sticky and other-writable (+t,o+w)
OTHER_WRITABLE 01;94			# ow: dir that is other-writable (o+w) and not sticky
STICKY 01;94					# st: dir with the sticky bit set (+t) and not other-writable

#+-------------------+
#+ Extension Pattern +
#+-------------------+
#+--- Archives ---+
.7z 1;33
.ace 1;33
.alz 1;33
.arc 1;33
.arj 1;33
.bz 1;33
.bz2 1;33
.cab 1;33
.cpio 1;33
.deb 1;33
.dz 1;33
.ear 1;33
.gz 1;33
.jar 1;33
.lha 1;33
.lrz 1;33
.lz 1;33
.lz4 1;33
.lzh 1;33
.lzma 1;33
.lzo 1;33
.rar 1;33
.rpm 1;33
.rz 1;33
.sar 1;33
.t7z 1;33
.tar 1;33
.taz 1;33
.tbz 1;33
.tbz2 1;33
.tgz 1;33
.tlz 1;33
.txz 1;33
.tz 1;33
.tzo 1;33
.tzst 1;33
.war 1;33
.xz 1;33
.z 1;33
.Z 1;33
.zip 1;33
.zoo 1;33
.zst 1;33

#+--- Audio ---+
.aac 00;91
.au 00;91
.flac 00;91
.m4a 00;91
.mid 00;91
.midi 00;91
.mka 00;91
.mp3 00;91
.mpa 00;91
.mpeg 00;91
.mpg 00;91
.ogg 00;91
.opus 00;91
.ra 00;91
.wav 00;91

#+--- Shell ---+
.sh 1;32
.bash 1;32
.bash_profile 1;32
.bashrc 1;32
.inputrc 1;32
.hushlogin 1;32
.zsh 1;32
.zshrc 1;32

#+--- Code ---+
.md 1;32 
.xml 1;32
.py 1;32 
.cpp 1;32
.hpp 1;32
.tex 1;32
.bib 1;32
.lua 1;32
.js 1;32 
.c 1;32  
.h 1;32  
.cs 1;32 
.java 1;32
.php 1;32
.rb 1;32

#+--- Data ---+
.json 0;95
.csv 0;95
.yaml 0;95
.h5 0;95

#+--- Documents ---+
.djvu 00;96
.doc 00;96
.docx 00;96
.dot 00;96
.odg 00;96
.odp 00;96
.ods 00;96
.odt 00;96
.otg 00;96
.otp 00;96
.ots 00;96
.ott 00;96
.pdf 00;96
.ppt 00;96
.pptx 00;96
.xls 00;96
.xlsx 00;96

#+--- Executables ---+
.app 01;92
.bat 01;92
.cmd 01;92
.exe 01;92

#+--- Ignores ---+
.bak 2;97
.BAK 2;97
.log 2;97
.log 2;97
.old 2;97
.OLD 2;97
.orig 2;97
.ORIG 2;97
.swo 2;97
.swp 2;97

#+--- Images ---+
.bmp 0;92
.cgm 0;92
.dl 0;92
.dvi 0;92
.emf 0;92
.eps 0;92
.gif 0;92
.jpeg 0;92
.jpg 0;92
.JPG 0;92
.mng 0;92
.pbm 0;92
.pcx 0;92
.pgm 0;92
.png 0;92
.PNG 0;92
.ppm 0;92
.pps 0;92
.ppsx 0;92
.ps 0;92
.svg 0;92
.svgz 0;92
.tga 0;92
.tif 0;92
.tiff 0;92
.xbm 0;92
.xcf 0;92
.xpm 0;92
.xwd 0;92
.xwd 0;92
.yuv 0;92

#+--- Video ---+
.anx 00;91
.asf 00;91
.avi 00;91
.axv 00;91
.flc 00;91
.fli 00;91
.flv 00;91
.gl 00;91
.m2v 00;91
.m4v 00;91
.mkv 00;91
.mov 00;91
.MOV 00;91
.mp4 00;91
.mpeg 00;91
.mpg 00;91
.nuv 00;91
.ogm 00;91
.ogv 00;91
.ogx 00;91
.qt 00;91
.rm 00;91
.rmvb 00;91
.swf 00;91
.vob 00;91
.webm 00;91
.wmv 00;91