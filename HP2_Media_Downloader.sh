#!/bin/bash
# System Downlaod Script for HyperPie
#
# Hyperpie - https://www.hyperpie.org - https://www.facebook.com/groups/1158678304181964/
#
# Author: Mik McLean <$currentusertech@gmail.com>
#
# Version: 0.2b

clear
currentuser=$(who | awk {'print $1'} | head -n1)

Normal='\e[0m'
Red='\e[31m'
Green='\e[92m'

if (( EUID == 0 )); then
  echo
  echo "ERROR: Please do not run the script as root or sudo."
  echo
  exit -3
fi

dialog --title "Warning" --msgbox 'Using this Script to download a new system will remove the old system and replace it, if you do not want to do this please exit now!!' 10 40

check_download () {
        if [ -f "/home/$currentuser/RetroPie/roms/$1" ];
        then
		rm -rf /home/$currentuser/RetroPie/roms/$1
		check_system "$1" "$2" "$3"
	else
		check_system "$1" "$2" "$3"
	fi
}

check_system () {
	if [ -d "/home/$currentuser/RetroPie/roms/$2" ]; 
	then
#		rm -rf /home/$currentuser/RetroPie/roms/$2
        	clear
        	download_file "$1" "$2" "$3"
	else
		download_file "$1" "$2" "$3"
        fi
}
download_file () {
        echo "Downloading "$1" Image/Snap Pack..."
        sleep 1
        echo
        echo "Please wait....."
        echo
        wget "http://hyperpie.teamzt.seedr.io/system_media/$1" -q --show-progress -P /home/$currentuser/RetroPie/roms/
        echo
        echo "Pack Download Complete"
        echo
        echo "Checking file for corruption...Please Wait...."
	echo
        md5="$(md5sum "/home/$currentuser/RetroPie/roms/$1" | awk {'print $1'})"
        if [ "$md5" == "$3" ]
        then
                echo
                echo -e "${Green}Matched MD5.....continuing${Normal}"
                echo
        else
                echo -e "${Red}Wrong MD5 - Please rerun the download${Normal}"
                exit
        fi
        echo -e "Extracting File....${Green}Please Wait${Normal}"
        echo
        7zr x "/home/$currentuser/RetroPie/roms/$1" -o/home/$currentuser/RetroPie/roms/ -aoa
	rm -rf "/home/$currentuser/RetroPie/roms/$1"
	echo
	echo
	read -n 1 -s -p "Complete...Press any key to return to the menu"
	clear
	exec "$0"
}



if [ ! -x "`which "$DIALOG"`" ]
then
    DIALOG=dialog
fi

TMPFILE=`mktemp` || exit 1

$DIALOG --menu \
    "Please select a System to Download:" 50 51\
    49\
        1 "Amiga - (4.9G)"\
        2 "Amiga CD 32 - (298M)"\
        3 "Amstrad CPC - (495M)"\
        4 "Arcade - (14G)"\
        5 "Atari 2600 - (884M)"\
        6 "Atari 5200 - (160M)"\
        7 "Atari 7800 - (126M)"\
        8 "Atari Lynx - (271M)"\
        9 "Bandai Wonderswan - (137M)"\
        10 "Bandai Wonderswan Color - (257M)"\
        11 "Coleco Vision - (186M)"\
        12 "Commodore 64 - (2.1G)"\
        13 "Daphne - (39M)"\
        14 "Game and Watch - (60M)"\
        15 "Megadrive-Japan - (415M)"\
        16 "Microsoft MSX - (781M)"\
        17 "Microsoft MSX 2 - (162M)"\
        18 "Microsoft MSX 2+ - (311M)"\
        19 "Nintendo 64 - (1.5G)"\
        20 "Nintendo DS - (3.3G)"\
        21 "Nintendo Entertainment System - (3.5G)"\
        22 "Nintendo Famicom - (1.4G)"\
        23 "Nintendo Famicom Disk System - (435M)"\
        24 "Nintendo Game Boy - (2.3G)"\
        25 "Nintendo Game Boy Advance - (5.5G)"\
        26 "Nintendo Game Boy Advance Hacks - (1.7M)"\
        27 "Nintendo Game BoyColour - (1.6G)"\
        28 "Nintendo SNES - (1.8G)"\
        29 "Nintendo Virtualboy - (35M)"\
        30 "PC Engine - (827M)"\
        31 "PC Engine CD - (376M)"\
        32 "Sc-3000 - (20M)"\
        33 "Scummvm - (160M)"\
        34 "Sega 32X - (141M)"\
        35 "Sega CD - (1005M)"\
        36 "Sega Dreamcast - (1.8G)"\
        37 "Sega Game Gear - (924M)"\
        38 "Sega Game Gear Hacks - (11M)"\
        39 "Sega Genesis Hacks - (18M)"\
        40 "Sega Mark iii - (110M)"\
        41 "Sega Master System - (1015M)"\
        42 "Sega Megadrive - (4.2G)"\
        43 "Sega Sg-1000 - (133M)"\
        44 "Sfc - (1.7G)"\
        45 "Sgfx - (19M)"\
        46 "SNK Neo Geo - (368M)"\
        47 "SNK Neo Geo Pocket - (16M)"\
        48 "SNK Neo Geo Pocket Colour - (81M)"\
        49 "Sony PSP - (452M)"\
        50 "Sony PSP Minis - (774M)"\
        51 "Sony PSX - (6.7G)"\
        52 "Supergrafx - (2.6M)"\
        53 "Turbografx 16 - (243M)"\
        54 "Turbografx 16 CD - (111M)"\
        55 "Vectrex - (16M)"\
        56 "Zmachine - (9.9M)"\
        57 "ZX Spectrum - (603M)" 2> $TMPFILE

STATUS=$?
ANSWER=`cat $TMPFILE`

if [ $STATUS != 0 ]
then 
    rm -f $TMPFILE
    exit 1
fi

MODE=0 # 0 = disabled; 2 = enabled
TYPE=0 # 1 = regular;  2 = subpixel
ORIENTATION=1 # 0 = BGR; 1 = RGB

case $ANSWER in
1) # Amiga - (4.9G)
        clear
        FILE=amiga.7z
        DIR=amiga
        ROMMD5=21f320ff405a07f37267091bf64a39d0
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
2) # Amiga CD 32 - (298M)
        clear
        FILE=amigacd32.7z
        DIR=amigacd32
        ROMMD5=2762aa38d5337b465bcbad41e99deabd
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
3) # Amstrad CPC - (495M)
        clear
        FILE=amstradcpc.7z
        DIR=amstradcpc
        ROMMD5=f474d345da64142f9821aeaa4b01b2d2
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
4) # Arcade - (14G)
        clear
        FILE=arcade.7z
        DIR=arcade
        ROMMD5=0e571882ef9997a6e372715b32287bd9
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
5) # Atari 2600 - (884M)
        clear
        FILE=atari2600.7z
        DIR=atari2600
        ROMMD5=f4b4627c66a6ff62982c0f58d3122be1
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
6) # Atari 5200 - (160M)
        clear
        FILE=atari5200.7z
        DIR=atari5200
        ROMMD5=fd6ec9dd4e8e9b8c0b3be35acc100a33
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
7) # Atari 7800 - (126M)
        clear
        FILE=atari7800.7z
        DIR=atari7800
        ROMMD5=dcd657f09156dc4f1997d174e6dcd3fd
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
8) # Atari Lynx - (271M)
        clear
        FILE=atarilynx.7z
        DIR=atarilynx
        ROMMD5=66b661367b7517c05595b9a4849607f4
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
9) # Bandai Wonderswan - (137M)
        clear
        FILE=c64.7z
        DIR=c64
        ROMMD5=41c4734d60f88c281234f3035b62fdf6
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
10) # Bandai Wonderswan Color - (257M)
        clear
        FILE=coleco.7z
        DIR=coleco
        ROMMD5=aabcf8b619f198af757dc64a1477a391
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
11) # Coleco Vision - (186M)
        clear
        FILE=daphne.7z
        DIR=daphne
        ROMMD5=eb7ecac8afc58ff0b1a2aea6e3794f47
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
12) # Commodore 64 - (2.1G)
        clear
        FILE=dreamcast.7z
        DIR=dreamcast
        ROMMD5=3199cf413edd7f4e163b0484b979551a
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
13) # Daphne - (39M)
        clear
        FILE=famicom.7z
        DIR=famicom
        ROMMD5=2f6e45642e5ab1e67c5191585c760f87
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
14) # Game and Watch - (60M)
        clear
        FILE=fds.7z
        DIR=fds
        ROMMD5=597a19c4ae79b0cdeac5e3bca218fcad
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
15) # Megadrive-Japan - (415M)
        clear
        FILE=gameandwatch.7z
        DIR=gameandwatch
        ROMMD5=0138088f5b0900eae534ef25f5fadf60
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
16) # Microsoft MSX - (781M)
        clear
        FILE=gamegear.7z
        DIR=gamegear
        ROMMD5=8862b98569daa39ada14d0db3bf01f2b
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
17) # Microsoft MSX 2 - (162M)
        clear
        FILE=gb.7z
        DIR=gb
        ROMMD5=9e8be0708e178551b9e1619adbf2b83d
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
18) # Microsoft MSX 2+ - (311M)
        clear
        FILE=gba.7z
        DIR=gba
        ROMMD5=44db4ea303b1e8dc7a2e42f2c1bbe38f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
19) # Nintendo 64 - (1.5G)
        clear
        FILE=gbah.7z
        DIR=gbah
        ROMMD5=a3b708cc50651885849f7aa1872c306f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
20) # Nintendo DS - (3.3G)
        clear
        FILE=gbc.7z
        DIR=gbc
        ROMMD5=f1f85afc7532ca2b7751b1ae0dd95b2f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
21) # Nintendo Entertainment System - (3.5G)
        clear
        FILE=genh.7z
        DIR=genh
        ROMMD5=4933f39c6a19018eae3b684060671d04
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
22) # Nintendo Famicom - (1.4G)
        clear
        FILE=ggh.7z
        DIR=ggh
        ROMMD5=9df4e9890e17e6e51352bc03faf02bdf
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
23) # Nintendo Famicom Disk System - (435M)
        clear
        FILE=markiii.7z
        DIR=markiii
        ROMMD5=b31051325850aee8cd9c82cc8af4e421
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
24) # Nintendo Game Boy - (2.3G)
        clear
        FILE=mastersystem.7z
        DIR=mastersystem
        ROMMD5=e9762aa05845d6ef7c823a4300a1b69c
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
25) # Nintendo Game Boy Advance - (5.5G)
        clear
        FILE=megadrive.7z
        DIR=megadrive
        ROMMD5=b5bc53c0758f00d8a877814250aad24f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
26) # Nintendo Game Boy Advance Hacks - (1.7M)
        clear
        FILE=megadrive-japan.7z
        DIR=megadrive-japan
        ROMMD5=2663823b67853a221a7e5e9b88bf070f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
27) # Nintendo Game BoyColour - (1.6G)
        clear
        FILE=msx2.7z
        DIR=msx2
        ROMMD5=edebc2f9b115155c7a993604533c7211
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
28) # Nintendo SNES - (1.8G)
        clear
        FILE=msx2+.7z
        DIR=msx2+
        ROMMD5=048403834ae1b05eda3d79df35291ec4
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
29) # Nintendo Virtualboy - (35M)
        clear
        FILE=msx.7z
        DIR=msx
        ROMMD5=6c207bd69f65ba358808a09ff644c062
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
30) # PC Engine - (827M)
        clear
        FILE=n64.7z
        DIR=n64
        ROMMD5=5d2b7da692166b7653917424ea45ba3a
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
31) # PC Engine CD - (376M)
        clear
        FILE=nds.7z
        DIR=nds
        ROMMD5=9f0ccf415b603550b2167207b25cd256
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
32) # Sc-3000 - (20M)
        clear
        FILE=neogeo.7z
        DIR=neogeo
        ROMMD5=b6668145cf8c48ca8b09c1723d633d14
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
33) # Scummvm - (160M)
        clear
        FILE=nes.7z
        DIR=nes
        ROMMD5=80b37cc992aad7d164063510892edfb7
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
34) # Sega 32X - (141M)
        clear
        FILE=ngp.7z
        DIR=ngp
        ROMMD5=db4ae05399d6de0e7b0422b94b4fe422
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
35) # Sega CD - (1005M)
        clear
        FILE=ngpc.7z
        DIR=ngpc
        ROMMD5=84ce57099c849deafc8f23df6c2b72ff
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
36) # Sega Dreamcast - (1.8G)
        clear
        FILE=pcengine.7z
        DIR=pcengine
        ROMMD5=5ebbec72d1ee0028105df8eb02b875d8
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
37) # Sega Game Gear - (924M)
        clear
        FILE=pcenginecd.7z
        DIR=pcenginecd
        ROMMD5=c3f59d8c5480f0416567f8c19961ba31
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
38) # Sega Game Gear Hacks - (11M)
        clear
        FILE=psp.7z
        DIR=psp
        ROMMD5=342655d993c822e3c09429cc8bf40b1a
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
39) # Sega Genesis Hacks - (18M)
        clear
        FILE=pspminis.7z
        DIR=pspminis
        ROMMD5=e6aa710c85fb0e033d1e64af2ee996f2
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
40) # Sega Mark iii - (110M)
        clear
        FILE=psx.7z
        DIR=psx
        ROMMD5=c47027bcbacb5fbaa5ddafbdd3e25fde
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
41) # Sega Master System - (1015M)
        clear
        FILE=sc-3000.7z
        DIR=sc-3000
        ROMMD5=729b10083bc5b1d4681d480a88c5d781
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
42) # Sega Megadrive - (4.2G)
        clear
        FILE=scummvm.7z
        DIR=scummvm
        ROMMD5=5d71767906ce450d78f84af25da8bc64
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
43) # Sega Sg-1000 - (133M)
        clear
        FILE=sega32x.7z
        DIR=sega32x
        ROMMD5=367a00e884027a53204612b66a6dbdc1
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
44) # Sfc - (1.7G)
        clear
        FILE=segacd.7z
        DIR=segacd
        ROMMD5=6e465ead036e3b6802d97492269aa4eb
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
45) # Sgfx - (19M)
        clear
        FILE=sfc.7z
        DIR=sfc
        ROMMD5=2a38ebed6e99875f650dbd4f6dba8b76
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
46) # SNK Neo Geo - (368M)
        clear
        FILE=sg-1000.7z
        DIR=sg-1000
        ROMMD5=1c56222c077c43a7864ba5121b9677d3
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
47) # SNK Neo Geo Pocket - (16M)
        clear
        FILE=sgfx.7z
        DIR=sgfx
        ROMMD5=3789848211ed9d0ecfcb0233f3c1b1ae
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
48) # SNK Neo Geo Pocket Colour - (81M)
        clear
        FILE=snes.7z
        DIR=snes
        ROMMD5=cc7e6a36a6031a8fa63ce995bd999792
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
49) # Sony PSP - (452M)
        clear
        FILE=supergrafx.7z
        DIR=supergrafx
        ROMMD5=bf49a9ab2622de9b1a4675f9af1c6b09
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
50) # Sony PSP Minis - (774M)
        clear
        FILE=tg16.7z
        DIR=tg16
        ROMMD5=dd38f92cb2fde04a8c71aa7ae53586f5
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
51) # Sony PSX - (6.7G)
        clear
        FILE=tg16cd.7z
        DIR=tg16cd
        ROMMD5=5094588c82e6f67a416a153cb3d15a22
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
52) # Supergrafx - (2.6M)
        clear
        FILE=vectrex.7z
        DIR=vectrex
        ROMMD5=a1f61c605741244b2bd307376be3c6f7
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
53) # Turbografx 16 - (243M)
        clear
        FILE=virtualboy.7z
        DIR=virtualboy
        ROMMD5=fa07fe6b62644cca80d45f38b369643f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
54) # Turbografx 16 CD - (111M)
        clear
        FILE=wonderswan.7z
        DIR=wonderswan
        ROMMD5=609d98a6c75ccae8715bfd374e1812dd
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
55) # Vectrex - (16M)
        clear
        FILE=wonderswancolor.7z
        DIR=wonderswancolor
        ROMMD5=ea91a54a32f552056c6a2d3fdab7e379
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
56) # Zmachine - (9.9M)
        clear
        FILE=zmachine.7z
        DIR=zmachine
        ROMMD5=5f74ec2b528faede0a33cd8cb6dbfdab
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
57) # ZX Spectrum - (603M)
        clear
        FILE=zxspectrum.7z
        DIR=zxspectrum
        ROMMD5=148cbb5c8be9ca977f57c8fa4a76a5bc
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
	*)
        rm -f $TMPFILE
        echo Unexpected option: $ANSWER
        exit 1
        ;;
esac
rm -f $TMPFILE
clear
