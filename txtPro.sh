#! /bin/bash

# Author: Albert Udoh Chiemezie
# Objective : Test result post processing
# Datum: 22.12.2020

# Convert result pdf file to txt file
pdftotext -layout $1 HLA_Output.txt


# Extract all lines that contains the keyword "Failed"
awk '/Failed/ {print}' HLA_Output.txt > HLA_Output_failed.txt



# Get all failed hardware information
awk 'BEGIN {print "SLOT MOD PART_NO\n" } NR>1 && NF > 15 {print $4, $6, $7, $8, $9,$10,$11,$12, $13}' HLA_Output_failed.txt | awk '!a[$0]++' > defective_hw_info.txt
cat defective_hw_info.txt    # print defective hardwares on screen



# Get all failure title, maintenance type
awk 'NF == 6{print $1, $4, NR}' HLA_Output_failed.txt


echo
echo # spacing

# read all the line in defective hardware txt and perform operation

HwFlagCounter = 0
while read -r line
do 
	#echo $line
	# return the id name for defective hardware
	awk '{printf("HLA_%s__%s_%s_%s\n", $NF, $2, $3, $4)}' $line # this line can be take outside the loop
								    # replace the $line with defective_hw_info.txt
	
done < defective_hw_info.txt



