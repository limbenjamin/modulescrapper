#	 This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#!/bin/bash
# This script scraps NUS IVLE site for module code,title,prereqs and precludes.
# Preconditions: 
#	200MB free space in directory
#	python installed and path configured
#	Unix system with dos2unix, awk, sed and normal unix utilities present
#	script.py and script2.py in same directory
#	Require a list of Modules in a txt file in same directory named modulelist.txt
#
#The script will create a .tsv file (tilde delimited values) of the module code, title,prereq and precludes in that order.

dos2unix modulelist.txt
awk '{print $1}' ./modulelist.txt > modulecode.txt #seperate module code
awk '{for (i = 2; i <= NF; i++) printf $i " ";printf "\n"}' ./modulelist.txt > modulename2.txt #seperate module name
mkdir ./temp #all processing in temp directory
cp ./script.py ./temp/script.py
cd ./temp
./script.py #wget module list
rm script.py
find ./ -type f -print0 | xargs -0 sed -i 's/<[^>]*>//g' #strip html tags
find ./ -type f -print0 | xargs -0 sed -i -e :a -e '$!N;s/\n//;ta' #remove all line breaks
cat * > txt #concat into a file
cp txt name # working file for parsing name
cp txt prereq
cp txt preclude
# parsing prereq
awk 'BEGIN{FS=OFS="Prereq"} NF>1{$1="";sub(/^- */, "")}'1 prereq > prereq2 #Remove everything before prereq for files with prereq
sed -i 's/^ .*//' prereq2 #Lines not starting whitespace = null
sed -i 's/Preclu.*//' prereq2 #remove everything after Preclu
sed -i 's/Cross-list.*//' prereq2 #remove everything after Cross-list
awk '{ sub(/[ \t]+$/, ""); print }' prereq2 > prereq #Remove trailing whitespace
awk '{ sub(/^Prerequisites/, ""); print }' prereq  > finalprereq #Remove Prerequisites title
# parsing name
awk 'BEGIN{FS=OFS="Module Title"} NF>1{$1="";sub(/^- */, "")}'1 name > name2
sed -i 's/^ .*//' name2 #Lines not starting whitespace = null
sed -i 's/Module Cre.*//' name2 
sed -i 's/Prereq.*//' name2 
awk '{ sub(/[ \t]+$/, ""); print }' name2 > name #Remove trailing whitespace
awk '{ sub(/^Module Title/, ""); print }' name  > finalname 
# parsing preclude
awk 'BEGIN{FS=OFS="Preclusions"} NF>1{$1="";sub(/^- */, "")}'1 preclude > preclude2 
sed -i 's/^ .*//' preclude2 #Lines not starting whitespace = null
sed -i 's/Cross-list.*//' preclude2 
sed -i 's/Workload Comp.*//' preclude2 
awk '{ sub(/[ \t]+$/, ""); print }' preclude2 > preclude #Remove trailing whitespace
awk '{ sub(/^Preclusions/, ""); print }' preclude > finalpreclude 
paste -d~ finalcode finaltitle finalprereq finalpreclude > ../final.tsv
cd ..
rm -rf ./temp
awk '{ sub(/^/, "~"); print }' final.tsv  > last.tsv //Add ~ in front #For GAE bulkloader you need a delimiter in front of first field as well
