clc;
clear;
A=[100,200,300;300,500,600;700,100,1000];

sortedValues = unique(A(:));          %# Unique sorted values
maxValues = sortedValues(end-0:end);  %# Get the 5 largest values
maxIndex = ismember(A,maxValues);     %# Get a logical index of all values
                                      %#   equal to the 5 largest values