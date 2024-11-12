################################################################################
# Some installation scripts will write to this file. If this file exists, it
# will be read and executed by the bash login shell, and the subsequent profile
# files, ~/.bash_login and ~/.profile (the generic sh profile) will be ignored.
# To prevent some installation writing to and creating any of these files and
# obfuscating an unintended profile change, keep this file, the first profile
# file checked for, and source the other two profile files here, plus the rc.
################################################################################

if [ -f ~/.bash_login ]; then . ~/.bash_login; fi
if [ -f ~/.profile ]; then . ~/.profile; fi
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
