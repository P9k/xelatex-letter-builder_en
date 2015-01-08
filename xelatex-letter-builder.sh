#! /bin/bash
#
#
#  -----------------------------------------------------------
#  |                "XeLaTeX-LetterBuilder"                    |
#  -----------------------------------------------------------

#  A Bash script to create automagically letters with XeLaTeX
#  
#   
#
#    Copyright (C) 2015  Paul Jerabek
#
# __________________________________________________________
# This program is free software; you can redistribute it and/or 
# modify it under the terms of the GNU General Public License as 
# published by the Free Software Foundation; either version 3 of 
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details. 
# __________________________________________________________
#
# This script will automatically create XeLaTeX letters in the Linux
# Libertine and Linux Biolinum font. For that, it will utilize the 
# scrlttr2 class out of the KOMA-Script package.
#
# After a series of questions the nano editor will open out in which
# the content of the letter can be inserted. After that a PDF document
# will be created.
#
# It is fairly easy to modify the script to one's need by just changing 
# some of the options and keywords in the XeLaTeX letter template.
#
# As a feature, this script will save the sender details (name, address etc.)
# in a directory called ~/.xelatex-letter-builder so it can be 
# easily loaded for later use. 
#
# Required packages: xelatex, fonts-linuxlibertine, nano
#
# 
# 
#  01/07/2015: Version 1.0
#
##############################################################



#
# definition of variables
#

DATE=`date +%Y-%m-%d`
MAINFONT="Linux Libertine O"
SANSFONT="Linux Biolinum O"
SAVEPATH="$HOME/.xelatex-letter-builder"
MYPWD=`pwd`

#
# definition of functions
#

function welcome {
echo ""
echo "#################################################"
echo "#    Welcome to the XeLaTeX-Letter-Generator!   #"
echo "#################################################"
echo ""
echo ""
echo ""
}

function sender {
SENDER=""
echo ""
while [ "$SENDER" == "" ]; do
        echo "#################################################"
        echo "Please enter the name of the sender! (q to quit)"
        read SENDER
        if [ "$SENDER" == "q" ]; then
                exit 0
        fi
done
echo "#################################################"
echo ""
echo ""
echo "Return address:"
echo ""
echo "Street and house number?"
read SENDERSTREET
echo ""
echo "Postal code and city?"
read SENDERCITY
echo ""
echo ""
echo "Telephone number?"
read TELEPHONE
if  [ "$TELEPHONE" == "" ]; then       # Empty?
	INSERTPHONE=""
else	
	INSERTPHONE="		\\usekomavar*{fromphone}  & \usekomavar{fromphone} \\\\"
fi
echo ""
echo ""
echo "Mobile phone number?"
read MOBILE
if  [ "$MOBILE" == "" ]; then
	INSERTMOBILE=""
else
	INSERTMOBILE="		\\usekomavar*{frommobile} & \usekomavar{frommobile}\\\\"
fi
echo ""
echo ""
echo "E-mail address?"
read MAILADDRESS
if  [ "$MAILADDRESS" == "" ]; then
        INSERTMAIL=""
else
        INSERTMAIL="        \\usekomavar*{fromemail}  & \usekomavar{fromemail} \\\\"
fi
echo ""
echo "Homepage?"
read HOMEPAGE
echo ""
if  [ "$HOMEPAGE" == "" ]; then
        INSERTURL=""
else
        INSERTURL="        \\usekomavar*{fromurl}    & \usekomavar{fromurl}"
fi
echo "#################################################"
echo ""
echo ""
}

function recipient {
RECIPIENT=""
echo ""
while [ "$RECIPIENT" == "" ]; do
        echo "#################################################"
        echo "Please enter the name of the recipient! (q zum Beenden)"
        read RECIPIENT
        if [ "$RECIPIENT" == "q" ]; then
                exit 0
        fi
done
echo ""
echo "#################################################"
echo ""
echo "Inside address:"
echo ""
echo "Street and house number?"
read RECIPIENTSTREET
echo ""
echo "Postal code and city?"
read RECIPIENTCITY
echo ""
echo "#################################################"
echo ""
echo ""
}

function city {
echo ""
echo "#################################################"
echo "City printed beside the date?"
read CITY_TEST
if [ "$CITY_TEST" != "" ]; then
	CITY="$CITY_TEST, "
fi
echo ""
echo "#################################################"
echo ""
echo ""
}

function senddate {
echo ""
echo "#################################################"
echo "Date? (Default: Today's)"
read SENDDATE
if  [ "$SENDDATE" == "" ]; then       # Name leer?
	SENDDATE="\today"
fi
echo ""
echo "#################################################"
echo ""
echo "" 
}

function subject {
echo ""
echo "#################################################"
echo "Regarding?"
read SUBJECT
echo ""
echo "#################################################"
echo ""
echo "" 
}

function opening {
echo ""
echo "#################################################"
echo "Opening? (Default: Dear Sir or Madam,)"
read OPENING
if  [ "$OPENING" == "" ]; then       # Empty?
        OPENING="Dear Sir or Madam,"
fi
echo ""
echo "#################################################"
echo ""
echo ""
}

function closing {
echo ""
echo "#################################################"
echo "Closing? (Default: Sincerely yours,)"
read CLOSING
if  [ "$CLOSING" == "" ]; then       # Empty?
        CLOSING="Sincerely yours,"
fi
echo ""
echo "#################################################"
echo ""
echo "" 
}

function attachments {
echo ""
echo "#################################################"
echo "Enclosures? (Seperate multiple enclosure through \\\\\\\\ from each other )"
read ATTACHMENTS
if [ "$ATTACHMENTS" == "" ]; then
	INSERTATTACHMENT="% \\encl{$ATTACHMENTS}"
else
	INSERTATTACHMENT=" \\encl{$ATTACHMENTS}"
fi
echo ""
echo "#################################################"
echo ""
echo "" 
}

function makedir {
FOLDERNAME=""
echo ""
while [ "$FOLDERNAME" == "" ]; do
	echo "#################################################"
	echo "Save under which name? (q to quit)"
	read FOLDERNAME
	if [ "$FOLDERNAME" == "q" ]; then
		exit 0
	fi
done
mkdir "$MYPWD/$DATE-$FOLDERNAME"
echo "#################################################"
echo ""
echo ""
}

function lettercontent {
CHECK="1"
echo ""
while [ "$CHECK" == "1" ]; do
	echo "#################################################"
	echo "Please enter the content of the letter. Just type"
        echo "in the text and press Ctrl+X, Y and 2x enter.    "
	echo ""
	echo "Press now enter to proceed and open the nano editor."
	echo ""
	read CHECK
done
touch $MYPWD/$DATE-$FOLDERNAME/lettercontent.dat
nano $MYPWD/$DATE-$FOLDERNAME/lettercontent.dat
LETTERCONTENT=`cat $MYPWD/$DATE-$FOLDERNAME/lettercontent.dat`
echo "#################################################"
echo ""
echo ""
}

function makealetter {
cd "$MYPWD/$DATE-$FOLDERNAME"
cat <<-EOF > "$FOLDERNAME".tex
%!TEX TS−program = xetex
%!TEX encoding = UTF−8 Unicode  

\\documentclass[UScommercial9,paper=letter]{scrlttr2}
\\usepackage[pass]{geometry}                  

\\KOMAoptions{parskip,locfield=wide,firsthead=false,enlargefirstpage}

\\setkomavar{fromname}{$SENDER}
\\setkomavar{fromaddress}{$SENDERSTREET\\\\$SENDERCITY}
\\setkomavar{fromphone}[Tel.: ]{$TELEPHONE}
\\setkomavar{fromemail}{$MAILADDRESS}
\\setkomavar{fromurl}[Website: ]{$HOMEPAGE}
\\newkomavar[Mobile:]{frommobile}
\\setkomavar{frommobile}{$MOBILE}

\\setkomavar{location}{%
    \\textbf{\usekomavar{fromname}}\\\\
    \\usekomavar{fromaddress}

    \\scriptsize
    \\begin{tabular}[t]{@{}l@{\ }l}
$INSERTPHONE
$INSERTMOBILE
                                 &                        \\\\
$INSERTMAIL
$INSERTURL
    \\end{tabular}

    \\usekomavar{frombank}
}

\\usepackage[english]{babel}
\\usepackage{graphicx}

\\usepackage{fontspec}% provides font selecting commands
\\usepackage{xunicode}% provides unicode character macros
\\usepackage[no-sscript]{xltxtra} % provides some fixes/extras. 
\\usepackage{fixltx2e}                 
\\usepackage{setspace} 		       
\\usepackage{ellipsis}                 

\\usepackage{amssymb}
\\usepackage{amsmath}
\\renewcommand{\glqq}{„}
\\renewcommand{\grqq}{“}

% Packages for xelatex----------------------

% \\usepackage{unicode-math}
% \\defaultfontfeatures{Mapping=tex-text, Numbers=OldStyle} 
\\defaultfontfeatures{Mapping=tex-text} 
\\setmainfont{$MAINFONT}
\\setsansfont{$SANSFONT}
% \\setmathfont[Scale=MatchLowercase]{Asana Math}  



\\begin{document}



% Date:
 \\setkomavar{date}{$CITY$SENDDATE}

\\setkomavar{subject}{$SUBJECT}

\\begin{letter}{%
    $RECIPIENT\\\\
    $RECIPIENTSTREET\\\\
    $RECIPIENTCITY
}

\\opening{$OPENING}

$LETTERCONTENT

\\closing{$CLOSING}

% \\ps PS:
$INSERTATTACHMENT
% \\cc{Verteiler}

\\end{letter}
\\end{document}
EOF
xelatex "$FOLDERNAME".tex
}

function savesender {
mkdir -p "$SAVEPATH"
cd "$SAVEPATH"
echo "$SENDER" > sender.dat
echo "$SENDERSTREET" > senderstreet.dat
echo "$SENDERCITY" > sendercity.dat
echo "$TELEPHONE" > telephone.dat
echo "$MOBILE" > mobile.dat
echo "$MAILADDRESS" > mailaddress.dat
echo "$HOMEPAGE" > homepage.dat
}

function checksavepath {
if [ -d "$SAVEPATH" ]; then
	loadsender
else sender
fi
}


function loadsender {
echo ""
echo "#################################################"
echo "Press Y/y to load the data about the last sender" 
echo "from $SAVEPATH."
echo ""
read LOADDATA
if [[ "$LOADDATA" == "Y" || "$LOADDATA" == "y" ]]; then
	cd "$SAVEPATH"
	if [ -f sender.dat ]; then
		SENDER=`cat sender.dat`
	fi
	if [ -f senderstreet.dat ]; then
	        SENDERSTREET=`cat senderstreet.dat`
	fi
	if [ -f sendercity.dat ]; then
	        SENDERCITY=`cat sendercity.dat`
	fi
	if [ -f telephone.dat ]; then
	        TELEPHONE=`cat telephone.dat`
	fi
	if [ -f mobile.dat ]; then
	        MOBILE=`cat mobile.dat`
	fi
	if [ -f mailaddress.dat ]; then
	        MAILADDRESS=`cat mailaddress.dat`
	fi
	if [ -f homepage.dat ]; then
	        HOMEPAGE=`cat homepage.dat`
	fi
	
	echo ""
	echo "#################################################"
	echo ""
	echo "Loaded the following data:"
	echo ""
	echo "- Sender: $SENDER"
	echo "- Return address: $SENDERSTREET, $SENDERCITY"
	echo "- Telephone number: $TELEPHONE"
	echo "- Mobile phone number: $MOBILE"
	echo "- E-mail address: $MAILADDRESS"
	echo "- Website: $HOMEPAGE"
	echo ""
	echo "#################################################"
	echo ""
	echo ""
else
	sender
fi
}

#
# Execute functions: Create letter
#


welcome
checksavepath
#loadsender
recipient
subject
city
senddate
opening
closing
attachments
makedir
lettercontent
makealetter
savesender

