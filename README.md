# xelatex-letter-builder_en
A Bash script to create automagically letters with XeLaTeX

This script will automatically create XeLaTeX (a version of LaTeX) letters in the Linux
Libertine and Linux Biolinum font. For that, it will utilize the 
scrlttr2 class out of the KOMA-Script package.

After a series of questions the nano editor will open out in which
the content of the letter can be inserted. After that a PDF document
will be created.

It is fairly easy to modify the script to one's need by just changing 
some of the options and keywords in the XeLaTeX letter template.

As a feature, this script will save the sender details (name, address etc.)
in a directory called ~/.xelatex-letter-builder so it can be 
easily loaded for later use. 

Required packages: xelatex, fonts-linuxlibertine, nano

 
 
  01/07/2015: Version 1.0

