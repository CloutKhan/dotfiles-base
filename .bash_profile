################################################################################
# Some installation scripts will write to this file. If this file exists, it
# will be read and executed by the bash login shell, and the subsequent profile
# files, ~/.bash_login and ~/.profile (the generic sh profile) will be ignored.
# To prevent some installation writing to and creating any of these files and
# obfuscating an unintended profile change, keep this file, the first profile
# file checked for, and source the other two profile files here.
################################################################################

source ~/.bash_login
source ~/.profile
