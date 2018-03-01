#!/bin/bash
# System Downlaod Script for HyperPie
#
# Hyperpie - https://www.hyperpie.org - https://www.facebook.com/groups/1158678304181964/
#
# Author: Mik McLean <haggistech@gmail.com>
#
# Version: 2.0
#
# Multi Select done by jolny <jolnyx@gmail.com>

FILES="$HOME/.attract/Attract Mode Setup/systems/"

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

W=()
while read -r line; do
    W+=("$line" off)
done < <( ls -1 "$FILES" )

choices=$(dialog --stdout --no-items \
        --separate-output \
        --ok-label "Download pack(s)" \
        --checklist "Select media sets to download (SPACE selects):" 22 76 16 \
        "${W[@]}")

if [[ $choices ]]
then
    while read -r line; do
        DIR=$(head -1 /home/$currentuser/.attract/Attract\ Mode\ Setup/systems/"$line")
        ROMMD5=$(head -2 /home/$currentuser/.attract/Attract\ Mode\ Setup/systems/"$line" | tail -1)
        #rm -rf /home/pi/RetroPie/roms/$DIR
        echo "Downloading "$DIR" Image/Snap Pack..."
        echo
        wget "http://www.retrohaggis.com/hp2_media/$DIR.7z" -q --show-progress -P /home/$currentuser/RetroPie/roms/
        echo
        echo "Pack Download Complete"
        echo
        sleep 1
        echo "Checking file for corruption...Please Wait...."
	echo
        md5="$(md5sum "/home/$currentuser/RetroPie/roms/$DIR.7z" | awk {'print $1'})"
        if [ "$md5" == "$ROMMD5" ]
        then
                echo
                echo -e "${Green}Matched MD5.....continuing${Normal}"
                echo
        else
                echo -e "${Red}Wrong MD5 - Please rerun the download${Normal}"
                exit
        fi
        echo -e "Extracting File....${Green}Please Wait${Normal}"
        sleep 2
        echo
        7zr x "/home/$currentuser/RetroPie/roms/$DIR.7z" -o/home/$currentuser/RetroPie/roms/ -aoa
        rm -rf "/home/$currentuser/RetroPie/roms/$DIR.7z"
    done < <( echo "$choices" )
echo "Done, returning to Attract Mode..."
sleep 2
exec $0
else
    echo "Cancelled, or no files chosen. Nothing downloaded."
fi
