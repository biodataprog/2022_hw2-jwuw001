#!/bin/bash

curl -o fires5000.csv https://gis.data.cnra.ca.gov/datasets/CALFIRE-Forestry::recent-large-fire-perimeters-5000-acres.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D

#Print out range of years
awk -F, '{print $2}' fires5000.csv | sort -n | head -n 5
awk -F, '{print $2}' fires5000.csv | sort -n | tail -n 5
nano fires5000.csv
#delete out the two extra 'enters' in the files - before 6901 and 48088
MINYEAR=2017
MAXYEAR=2021
echo "This report has the years: $MINYEAR-$MAXYEAR"

#Print out number of fires in database
awk -F, '{print $2}' fires5000.csv | tail -n +2 | wc -l
#     134
TOTALFILECOUNT=134
echo "Total number of files: $TOTALFILECOUNT"

#Number fires per year
echo "Number of fires in each year follows:"
awk -F, '{print $2}' fires5000.csv | sort -n | uniq -c | tail -n +2
#     39 2017
#     21 2018
#     11 2019
#     44 2020
#     19 2021

#Print out largest fire name
awk -F, '{print $13,$6}' fires5000.csv | sort -nr | head -5
#     1032699.6 AUGUST COMPLEX

awk -F, '{print $2}' fires5000.csv | sort -n | uniq | tail -n +2 > years.txt

#Print out total acreage burned each year
years_list=$(cat years.txt)
for YEAR in $years_list
  do
     TOTAL=$(grep $YEAR fires5000.csv | awk -F',' '{sum+=$13;} END{print sum;}')
     echo "In Year $YEAR, Total was $TOTAL"
  done

#Sum of all fire acreage across all years
cut -d, -f2,13 fires5000.csv | head -1 | awk -F',' '{sum+=$2;} END{print sum;}'
