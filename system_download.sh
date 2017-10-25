#!/bin/bash
# System Downlaod Script for HyperPie
#
# Hyperpie - https://www.hyperpie.org - https://www.facebook.com/groups/1158678304181964/
#
# Author: Mik McLean <haggistech@gmail.com>
#
# Version: 0.2b

clear

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' p7zip|grep "install ok installed")
echo Checking for 7-Zip: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo
  echo "7-Zip is required but not found.....Installing now"
  sudo apt-get --assume-yes install p7zip > /dev/null
  echo
  echo "Installed"
  sleep 2
fi

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
        if [ -f "$1" ];
        then
		rm -rf $1
		check_system "$1" "$2" "$3"
	else
		check_system "$1" "$2" "$3"
	fi
}

check_system () {
	if [ -d "$2" ]; 
	then
		rm -rf $2
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
        wget "http://www.retrohaggis.com/systems/$1" -q --show-progress
        echo
        echo "Pack Download Complete"
	echo
        md5="$(md5sum "$1" | awk {'print $1'})"
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
        7zr x "$1"
	rm -rf "$1"
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
	1 "Amstrad PC - (434M)"\
	2 "Arcade - (5.3G)"\
	3 "Atari 2600 - (693M)"\
	4 "Atari 5200 - (62M)"\
	5 "Atari 7800 - (122M)"\
	6 "Atari Lynx - (180M)"\
	7 "Coleco Vision - (92M)"\
	8 "Commodore 64 - (1.4G)"\
	9 "Daphne - (40M)"\
	10 "Dreamcast - (1011M)"\
	11 "Famicom - (630M)"\
	12 "Famicom Disk System - (79M)"\
	14 "Game and Watch - (60M)"\
	18 "Sega Mark III - (110M)"\
	19 "Sega Megadrive (Japan) - (415M)"\
	20 "MSX 2 - (101M)"\
	21 "MSX 2+ - (311M)"\
	22 "MSX - (513M)"\
	23 "Neogeo - (332M)"\
	24 "Neogeo Pocket - (14M)"\
	25 "Neogeo Pocket Colour - (66M)"\
	26 "Nintendo DS - (3.1G)"\
	27 "Nintendo Entertainment System - (1.6G)"\
	28 "Nintendo Game Boy - (1.2G)"\
	29 "Nintendo Game Boy Advance - (2.6G)"\
	30 "Nintendo Game Boy Advance Hacks - (1.7M)"\
	31 "Nintendo Game Boy Colour - (1.2G)"\
	32 "Nintendo N64 - (710M)"\
	34 "PC Engine - (519M)"\
	35 "PC Engine CD - (329M)"\
	36 "PSP - (452M)"\
	37 "PSP Minis - (774M)"\
	38 "PSX - (4.1G)"\
	39 "Sega SC-3000 - (20M)"\
	40 "Scumm VM - (160M)"\
	41 "Sega 32x - (97M)"\
	42 "Sega CD - (337M)"\
	43 "Sega Game Gear - (700M)"\
	44 "Sega Game Gear Hacks - (11M)"\
	45 "Sega Genesis Hacks - (18M)"\
	46 "Sega Master System - (616M)"\
	47 "Sega Mega Drive - (1.9G)"\
	48 "Super Famicon - (1.3G)"\
	49 "Sega SG-1000 - (86M)"\
	50 "NEC SuperGfx - (19M)"\
	51 "Super Nintendo - (1.6G)"\
	52 "TurboGfx 16 - (214M)"\
	53 "TurboGfx 16 CD - (83M)"\
	54 "Vectrex - (20M)"\
	56 "virtualboy - (33M).7z"\
	57 "wonderswan - (134M)"\
	58 "wonderswancolor - (87M)"\
	59 "zmachine - (9.9M)"\
	60 "ZX Spectrum - (603M)" 2> $TMPFILE

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
1) # Amstrad PC - (434M)
        clear
        FILE=Amstrad\ PC.7z
        DIR=amstradpc
	ROMMD5=b988c0e2ff5ad944a0230b161aa626c3
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
2) # Arcade - (5.3G)
        clear
	        FILE=Arcade.7z
        DIR=arcade
	ROMMD5=4affcde5bfd23531deb0cdf9d6eb7425
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
3) # Atari 2600 - (693M)
        clear
        FILE=Atari\ 2600.7z
        DIR=atari2600
	ROMMD5=df4b3c99009b1f1c6026fd92f8fdf158
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
4) # Atari 5200 - (62M)
        clear
        FILE=Atari\ 5200.7z
        DIR=atari5200
	ROMMD5=33950ffcfd849f62216faecb6837c7f3
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
5) # Atari 7800 - (122M)
        clear
        FILE=Atari\ 7800.7z
        DIR=atari7800
	ROMMD5=c87b937a73bd1fc6ed203769e0f9d188
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
6) # Atari Lynx - (180M)
        clear
        FILE=Atari\ Lynx.7z
        DIR=atarilynx
	ROMMD5=39c3ec0b67d24d996a77e5ddf5a5676a
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
7) # Coleco Vision - (92M)
        clear
        FILE=Coleco\ Vision.7z
        DIR=coleco
	ROMMD5=f5ff34919948416c24237796a3d6c2ea
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
8) # Commodore 64 - (1.4G)
        clear
	FILE=Commodore\ 64.7z
        DIR=c64
	ROMMD5=381390f1a71e1e404ff1ce0479317058
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
9) # Daphne - (40M)
        clear
	FILE=Daphne.7z
        DIR=daphne
        ROMMD5=71cde7bdb2904846bbbb8bc0a67d226e
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
10) # Dreamcast - (1011M)
        clear
        FILE=Dreamcast.7z
        DIR=dreamcast
	ROMMD5=e3d943bfecc3627e261aa24a6a44e017
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
11) # Famicon - (630M)
        clear
        FILE=Famicom.7z
        DIR=famicon
	ROMMD5=78fd66295b8fa8af2f96d63fa9f72a5f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
12) # Famicon Disk System - (79M)
        clear
        FILE=fds.7z
        DIR=fds
	ROMMD5=c5e6583fc1290a7e568e3042093a0137
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
14) # Game and Watch - (60M)
        clear
        FILE=Game\ and\ Watch.7z
        DIR=gameandwatch
	ROMMD5=dc6068eaa84a87ea02b5b31ca780c4ef
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
18) # Sega Mark III - (110M)
        clear
        FILE=markiii.7z
        DIR=markiii
	ROMMD5=b31051325850aee8cd9c82cc8af4e421
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
19) # Sega Megadrive (Japan) - (415M)
        clear
        FILE=megadrive-japan.7z
        DIR=megadrive-japan
	ROMMD5=7af10929cd6f774a423b45a8b397a30f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
20) # MSX 2 - (101M)
        clear
        FILE=MSX\ 2.7z
        DIR=msx2
	ROMMD5=3e0116ede36caa9a5c9042da6b89366d
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
21) # MSX 2+ - (311M)
        clear
        FILE=MSX\ 2+.7z
        DIR=msx2+
	ROMMD5=048403834ae1b05eda3d79df35291ec4
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
22) # MSX - (513M)
        clear
        FILE=MSX.7z
        DIR=msx
	ROMMD5=74d4b1d5785d55f298616876fd59c94c
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
23) # Neogeo - (332M)
        clear
        FILE=Neogeo.7z
        DIR=neogeo
	ROMMD5=972916f751ef63921a3cdbabd087981e
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
24) # Neogeo Pocket - (14M)
        clear
        FILE=Neogeo\ Pocket.7z
        DIR=ngp
	ROMMD5=9d35de607e2de8f2cbe3c9ea6366b7d8
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
25) # Neogeo Pocket Colour - (66M)
        clear
        FILE=Neogeo\ Pocket\ Colour.7z
        DIR=ngpc
	ROMMD5=37c8f36e718b2f78ee7c62d00db3720e
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
26) # Nintendo DS - (3.1G)
        clear
        FILE=Nintendo\ DS.7z
        DIR=nds
	ROMMD5=6782a96f0e5e310aa4e1973feb87acb6
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
27) # Nintendo Entertainment System - (1.6G)
        clear
        FILE=Nintendo\ Entertainment\ System.7z
        DIR=nes
	ROMMD5=4176328f8d18cc8afa4081cc15a12097
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
28) # Nintendo Game Boy - (1.2G)
        clear
        FILE=Nintendo\ Game\ Boy.7z
        DIR=gb
	ROMMD5=a0826b74b42b3f2bf129ab52da618d2f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
29) # Nintendo Game Boy Advance - (2.6G)
        clear
        FILE=Nintendo\ Game\ Boy\ Advance.7z
        DIR=gba
	ROMMD5=02338bdc00bae71a798c4d76186c588a
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
30) # Nintendo Game Boy Advance Hacks - (1.7M)
        clear
        FILE=Nintendo\ Game\ Boy\ Advance\ Hacks.7z
        DIR=gbah
	ROMMD5=a3b708cc50651885849f7aa1872c306f
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
31) # Nintendo Game Boy Colour - (1.2G)
        clear
        FILE=Nintendo\ Game\ Boy\ Colour.7z
        DIR=gbc
	ROMMD5=ddc0c6a5b37d92b4c2376f1ce3ace986
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
32) # Nintendo N64 - (710M)
        clear
        FILE=Nintendo\ N64.7z
        DIR=n64
	ROMMD5=be6d95956b5c270d9ec3b01ec7de2409
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
34) # PC Engine - (519M)
        clear
        FILE=pcengine.7z
        DIR=pcengine
	ROMMD5=70600aa5bdaacacadcc76270fca66506
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
35) # PC Engine CD - (329M)
        clear
        FILE=pcenginecd.7z
        DIR=pcenginecd
	ROMMD5=8e8934bdaf6ad5620726a9c45788a838
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
36) # PSP - (452M)
        clear
        FILE=PSP.7z
        DIR=psp
	ROMMD5=342655d993c822e3c09429cc8bf40b1a
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
37) # PSP Minis - (774M)
        clear
        FILE=PSP\ Minis.7z
        DIR=pspminis
	ROMMD5=e6aa710c85fb0e033d1e64af2ee996f2
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
38) # PSX - (4.1G)
        clear
        FILE=PSX.7z
        DIR=psx
	ROMMD5=6e971a87d5a588a71a7209539a5ab918
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
39) # Sega SC-3000 - (20M)
        clear
        FILE=sc-3000.7z
        DIR=sc-3000
	ROMMD5=729b10083bc5b1d4681d480a88c5d781
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
40) # Scumm VM - (160M)
        clear
        FILE=Scumm\ VM.7z
        DIR=scummvm
	ROMMD5=5d71767906ce450d78f84af25da8bc64
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
41) # Sega 32x - (97M)
        clear
        FILE=Sega\ 32x.7z
        DIR=sega32x
	ROMMD5=6b6798d57ea3e4305f5317ae8dccb392
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
42) # Sega CD - (337M)
        clear
        FILE=Sega\ CD.7z
        DIR=segacd
	ROMMD5=10d6b66d1bc7b38fb3344f2339949dfa
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
43) # Sega Game Gear - (700M)
        clear
        FILE=Sega\ Game\ Gear.7z
        DIR=gamegear
	ROMMD5=0f5de35057611c3c893025026549a6c3
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
44) # Sega Game Gear Hacks - (11M)
        clear
        FILE=Sega\ Game\ Gear\ Hacks.7z
        DIR=ggh
	ROMMD5=9df4e9890e17e6e51352bc03faf02bdf
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
45) # Sega Genesis Hacks - (18M)
        clear
        FILE=Sega\ Genesis\ Hacks.7z
        DIR=genh
	ROMMD5=4933f39c6a19018eae3b684060671d04
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
46) # Sega Master System - (616M)
        clear
        FILE=Sega\ Master\ System.7z
        DIR=mastersystem
	ROMMD5=1b8c70decf98483355782495d637b4ee
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
47) # Sega Mega Drive - (1.9G)
        clear
        FILE=Sega\ Mega\ Drive.7z
        DIR=megadrive
	ROMMD5=c165ae7107790e05f087a4a20549d350
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
48) # Super Famicom - (1.3G)
        clear
        FILE=sfc.7z
        DIR=sfc
	ROMMD5=d7ee5f4165a05fdc3e27c72899e94976
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
49) # Sega SC-3000 - (86M)
        clear
        FILE=sg-1000.7z
        DIR=sg-1000
	ROMMD5=5c2f374796fdc5af8ec7a88c35d1d442
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
50) # NEC Supergrafx - (19M)
        clear
        FILE=sgfx.7z
        DIR=sgfx
	ROMMD5=3789848211ed9d0ecfcb0233f3c1b1ae
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
51) # Super Nintendo - (1.6G)
        clear
        FILE=Super\ Nintendo.7z
        DIR=snes
	ROMMD5=04b28d24323022165d338f3fd9b0df41
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
52) # TurboGfx 16 - (214M)
        clear
        FILE=TurboGfx\ 16.7z
        DIR=tg16
	ROMMD5=dee141c332a84345c4d7f56351582cf6
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
53) # TurboGfx 16 CD - (83M)
        clear
        FILE=TurboGfx\ 16\ CD.7z
        DIR=tg16cd
	ROMMD5=1260ba1cbea229174d1d529ff7f1b79d
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
54) # Vectrex - (20M)
        clear
        FILE=Vectrex.7z
        DIR=vectrex
	ROMMD5=9e1d613f2117088b4076f047f9ee1453
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
56) # virtualboy - (33M)2).7z
        clear
        FILE=virtualboy.7z
        DIR=virtualboy
	ROMMD5=e8bb34eb20b1e560bad7593305077975
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
57) # wonderswan - (134M)
        clear
        FILE=wonderswan.7z
        DIR=wonderswan
	ROMMD5=66d049dec7333b8087df98d0cf2b9838
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
58) # wonderswancolor - (87M)
        clear
        FILE=wonderswancolor.7z
        DIR=wonderswancolor
	ROMMD5=31c64bb88c6727c7d9d4332ffd8e9e22
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
59) # zmachine - (9.9M)
        clear
        FILE=zmachine.7z
        DIR=zmachine
	ROMMD5=5f74ec2b528faede0a33cd8cb6dbfdab
        check_download "$FILE" "$DIR" "$ROMMD5"
        ;;
60) # ZX Spectum - (603M)
        clear
        FILE=ZX\ Spectrum.7z
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
