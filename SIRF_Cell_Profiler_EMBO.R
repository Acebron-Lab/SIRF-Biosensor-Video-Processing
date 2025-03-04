library(tidyverse)
library(readxl)
#Download the necessary packages to read excel and to process the data via TidyVerse
Conditions <- read_excel("(Please use your own input directory)")
#The conditons excel should in one column have the title "Condition" and in the second column "Time".
#The pathway will depend on your personal set up.
#In the "Condition" column, the condition should occupy as many rows as it takes to match each individual time points for the "pivot_wider" function to work.
Processed_Data <- read.csv("(Please use your own input directory)") %>% select(1:3,8) %>% rename(Integrated_Intensity = Mean_Biosensor_Signal_Intensity_IntegratedIntensity_Biosensor_Signal_Masked) %>% 
mutate(Integrated_Intensity = ifelse(is.nan(Integrated_Intensity), 0, Integrated_Intensity))
#Upload the single cell data obtained from Cell Profiler. The pathway and name of the file will depend on your personal set up.
#The data is then condensed to contain the following columns: "ImageNumber" which contains the specific condition and time point,
#"ObjectNumber" which contains the individual cell, "Children_Biosensor_Signal_Count" which contains the number of biosensor puncti per cell
#and "Mean_Biosensor_Signal_Intensity_IntegratedIntensity_Biosensor_Signal_Masked" which contains the averaged integrated intensity
#of biosensor signal per cell. The last column is then renamed for convenience.
#In the newly named "Integrated_Intensity" column, all NaN values are changed to zero.
Integrated_Intensity <- Processed_Data %>% group_by(ImageNumber) %>% summarize(Mean_Integrated_Intensity = mean(Integrated_Intensity, na.rm = TRUE))
Integrated_Intensity <- bind_cols(Conditions, Integrated_Intensity) %>% select(1,2,4)
Integrated_Intensity <- Integrated_Intensity %>% pivot_wider(names_from = Condition, values_from = Mean_Integrated_Intensity)
#To create a concise table for the Integrated Intensity per condition and time, the Integrated Intensity
#of all cells per condition and time are averaged. Afterwards the averaged data is merged to your "Conditions" excel sheet
#for proper designation of each value. With the new designations, the now redundant ObjectNumber column is removed so that the data
#can be processed further. Afterwards the pivot_wider function is applied to rearrange the data so that
#the columns will contain the Integrated Intensity values of each condition and each row will contain
#the Integrated Intenstiy values of each time point.
write_csv(Integrated_Intensity, "(Please use your own output directory)")
#Saves the new table in a CSV format

Cells <- Processed_Data %>% group_by(ImageNumber) %>% summarize(Positive_Cells = sum(Children_Biosensor_Signal_Count > 0)/length(Children_Biosensor_Signal_Count)*100)
Cells <- bind_cols(Conditions, Cells) %>% select(1,2,4)
Cells <- Cells %>% pivot_wider(names_from = Condition, values_from = Positive_Cells)
#To create a concise table for the percentage of biosensor activated cells per condition and time,
#all cells with more than one biosensor punctae are devided by the total number of cells per time and condition
#and multiplied by 100 to give a percentage.
#Afterwards the averaged data is merged to your "Conditions" excel sheet for proper designation of each value.
#With the new designations, the now redundant ObjectNumber column is removed so that the data can be processed further.
#Afterwards the pivot_wider function is applied to rearrange the data so that the columns will contain the values of percent activated cells of each condition and each row will contain
#the values of percent activated cells of each condition and time point.
write_csv(Cells, "(Please use your own output directory)")
#Saves the new table in a CSV format