# Processing of ND2 SIRF Biosensor videos for further downstream analysis.
## Renaming of files:
The Nikon Ti2 saves each individual position as a time lapse during live cell imaging of the cell line with the SIRF biosensor and the file is automatically assigned a numerical value.
Cell Profiler, however organizes the files lexically and not numerically, which can throw the the files/conditions out of order. In order to make the files in lexical order,
extra zeros are added in front of the numerical values. The code is in bash and is to be run on Terminal. This is done by first calling on the directory that has your nd2 files and adding extra zeros. E.g. 1 -> 001.
The only edit that must be done manually is to add your own correct directory in the "dir =" line. The rest of the program must simply be run. 

## Original Bfconvert Code: 
The original bfconvert command (Copyright (c) 2020, VolkerH) can be downloaded through the following link: 

https://github.com/VolkerH/Tutorial-on-bftools-and-bfconvert

The purpose of this code is to break each video into individual frames, which as a result could be processed downstream by Cell Profiler.

## Expanded Bfconvert Code:
The code was further expanded to function in a loop in order to process multiple videos simulaneously. An input directory is called for the nd2 files and an output file is called for where the 
nd2 files processed by bfconvert are saved. These two directories must be edited manually. The loop merely applies the bfconvert to each nd2 file in the directory, without you having to do it manually. The code is in bash and is to be run on Terminal.
In the output directory, each individual frame is saved in a folder corresponding to the original nd2 file as a TIFF file.
"C%c" idenfies the channel of the original nd2 file and "T%t" identifies the time point of the original nd2 file.
