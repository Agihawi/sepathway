#!/usr/bin/env python

# Script to clean pathway output files
import os
import re
import sys
import glob
import argparse


#build a wee argument parser
parser = argparse.ArgumentParser(description='Script to clean pathway output files')
parser.add_argument('--input', '-i', nargs=1, required=True, type=str, help='Specify Input file')
parser.add_argument('--output', '-o', nargs=1, required=True, type=str, help='Specify Output file')
args=parser.parse_args()

input_file = args.input[0]
output_file = args.output[0]

print('Input File: %s' %input_file)
print('Output File: %s' %output_file)

#check if input exists and make sure output doesn't
if not os.path.exists(input_file):
    raise ValueError('Could not find input: %s' %input_file)
if os.path.exists(output_file):
    raise ValueError('Output already present: %s' %output_file)

#open input file containing pathways
with open(input_file, 'rt') as infile:
    dirty_file = infile.readlines()

#declare list for clean pathways
clean_pathways= []

#clean up the pathways by getting rid of surplus strings
for line in dirty_file:
    clean_line = line[20:-3]
    clean_pathways.append(clean_line)

clean_pathways.sort()

#write output to file
with open(output_file, 'wt') as outfile:
    outfile.writelines("%s\n" %pathway for pathway in clean_pathways)

print('Script Complete')
