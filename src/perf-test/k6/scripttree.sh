#!/bin/bash - 
#===============================================================================
#
#          FILE: RecursiveDir.sh
# 
#         USAGE: bash RecursiveDir.sh [directory] [longest deepth] [empty]
# 
#   DESCRIPTION: This script can list the files and dirs 
# 								recursively in the current directory
# 								if empty argument is set to "empty", it will print a empty line 
# 								before and after a directory
# 
#       OPTIONS: longest_deepth	is set to 4 by default
# 							 directory is set to current directory by default 
# 								empty argument is set to "n" by default

#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: It print a empty line after a directory
#        AUTHOR: liuxueyang (lxy), liuxueyang457@163.com
#  ORGANIZATION: Hunan University
#       CREATED: 08/02/2014 20:52
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# this function used to print a empty line before or after a directory
printempty()
{
	if [ $empty = "empty" ]; then 
			NumberOfVeri=$[${#tab}/2+1]
			count=0
			while [ $count -lt $NumberOfVeri ]
			do 
				echo -n $veri
				echo -n '       ' # This is 7 spaces
				count=$[$count+1]
			done
			echo
		fi 
}

# This function is recursive 
# It lists the files and directories in the current dir 
recdir()
{
	tab=$tab$singletab
	# to test whether the deepth is greater than required
	if [ ${#tab} -gt $nu ]
	then 
		## Note that we must delete a tab before we go upper directory!
		tab=${tab%"\t"}
		return
	fi

	for file in "$@"
	do
# 		echo -en $tab$file
# 		minus_tab=${tab%"\t"}
# 		echo -en $minus_tab

		# print vertical lines
		NumberOfVeri=$[${#tab}/2-1]
		count=0
		while [ $count -lt $NumberOfVeri ]
		do 
			echo -n $veri
			echo -n '       ' # This is 7 spaces
			count=$[$count+1]
		done

		echo -n $veri
		# print horizonal lines
		count=0
		while [ $count -lt 7 ]
		do
			echo -n "-"
			count=$[$count+1]
		done
		echo -n $file

		# we get the path from original directory of the current file 
		# or directory
		thisfile=$thisfile/$file

		if [ -d "$thisfile" ]
		then 
			echo /

			# add empty line before a directory begins
			printempty

			# we force 'ls' to be a builtin command instead of some function 
			# or alias that we create by ourself
			recdir $(command ls $thisfile)

			# add an empty line after a directory ends
			printempty

		else 
			echo
		fi

		# we must set thisfile to be the current directory
		thisfile=${thisfile%/*}
	done

	# we delete a tab when we get to the upper directory
	tab=${tab%"\t"}
}

# This function init
recls() 
{
	tab=""
	singletab="\t"
	list=$(ls $1)
	for tryfile in $list    #### HERE! WE CAN NOT WRITE "$list" or shell will 
													#### treat it as one variable!!!!
													#### I deserve it! :-(
	do
		echo -n $tryfile
		## fix a BUG in book:
		## we add $1 in order to use any available directory 
		## instead of only current directory of the script path
		tryfile=$1/$tryfile
		if [ -d $tryfile ]
		then 
			echo /

			# add empty line before a directory begins
			printempty

			thisfile=$tryfile
			recdir $(command ls $tryfile)

			# add an empty line after a directory ends
			printempty

		else 
			echo
		fi
	done

	# we unset these variables cause we do not use them 
	# By the way, in order not to overwrite system command 
	# in some other script it is better to do this.
	unset dir singletab tab
}

result=${1:-"."}
nu=${2:-4}
nu=$[($nu-1)*2]
empty=${3:-"n"}

# this two variable are used to draw
hori="-"
veri="|"

recls $result

exit 0

