library(tidyverse)
library(readxl)
#Download the necessary packages to read excel and to process the data via TidyVerse
Conditions <- read_excel("(Please use your own input directory)")
#The conditons excel should in one column have the title "Condition" and in the second column "Time".
#The pathway will depend on your personal set up.
#In the "Condition" column, the condition should occupy as many rows as it takes to match each individual time points for the "pivot_wider" function to work.
Processed_Data_Transfected <- read.csv("(Please use your own input directory)") %>% select(1:3,8) %>% rename(Integrated_Intensity = Mean_Biosensor_Signal_Intensity_IntegratedIntensity_Biosensor_Signal_Masked) %>% 
mutate(Integrated_Intensity = ifelse(is.nan(Integrated_Intensity), 0, Integrated_Intensity))
#Data for transfected cells only:
#Upload the single cell data obtained from Cell Profiler. The pathway and name of the file will depend on your personal set up.
#The data is then condensed to contain the following columns: "ImageNumber" which contains the specific condition and time point,
#"ObjectNumber" which contains the individual cell, "Children_Biosensor_Signal_Count" which contains the number of biosensor puncti per cell
#and "Mean_Biosensor_Signal_Intensity_IntegratedIntensity_Biosensor_Signal_Masked" which contains the averaged integrated intensity
#of biosensor signal per cell. The last column is then renamed for convenience.
#In the newly named "Integrated_Intensity" column, all NaN values are changed to zero.
min_value <- 1
max_value <- 418
#The min and max value correspond to the number of image sets (e.g. each individual condition and time). Min_value should always be one and
#max_value depends on the maximum number of image sets and must be adjusted manually.
Integrated_Intensity_Transfected <- Processed_Data_Transfected %>% group_by(ImageNumber) %>% summarize(Mean_Integrated_Intensity = mean(Integrated_Intensity, na.rm = TRUE))
Integrated_Intensity_Transfected <- Integrated_Intensity_Transfected %>% complete(ImageNumber = seq(min_value, max_value)) %>% mutate(Mean_Integrated_Intensity = ifelse(is.na(Mean_Integrated_Intensity), 0, Mean_Integrated_Intensity)) %>% arrange(ImageNumber)
Integrated_Intensity_Transfected <- bind_cols(Conditions, Integrated_Intensity_Transfected) %>% select(1,2,4)
Integrated_Intensity_Transfected <- Integrated_Intensity_Transfected %>% pivot_wider(names_from = Condition, values_from = Mean_Integrated_Intensity)
#To create a concise table for the Integrated Intensity per condition and time of transfected cells, the Integrated Intensity of all cells per condition and time are averaged. 
#If an image set did not have a single cell with a plasmid (most commonly occurs at timepoint zero), it will not be included and thus will throw all of your data out of order.
#In order to avoid this, we tell R that there should be (in this example) 418 image sets, fill in the few that are missing and add zero for the values since there is no biosensor signal
#Afterwards the averaged data is merged to your "Conditions" excel sheet for proper designation of each value. 
#With the new designations, the now redundant ObjectNumber column is removed so that the data can be processed further. 
#Afterwards the pivot_wider function is applied to rearrange the data so that
#the columns will contain the Integrated Intensity values of each condition and each row will contain
#the Integrated Intenstiy values of each time point.
write.csv(Integrated_Intensity_Transfected, "(Please use your own output directory)")
#Saves the new table.
Cells_Transfected <- Processed_Data_Transfected %>% group_by(ImageNumber) %>% filter(!is.nan(Children_Biosensor_Signal_Count))
Cells_Transfected <- Cells_Transfected %>% group_by(ImageNumber) %>% summarize(Positive_Cells = sum(Children_Biosensor_Signal_Count > 0)/length(Children_Biosensor_Signal_Count)*100)
Cells_Transfected <- Cells_Transfected %>% complete(ImageNumber = seq(min_value, max_value)) %>% mutate(Positive_Cells = ifelse(is.na(Positive_Cells), 0, Positive_Cells)) %>% arrange(ImageNumber)
Cells_Transfected <- bind_cols(Conditions, Cells_Transfected) %>% select(1,2,4)
Cells_Transfected <- Cells_Transfected %>% pivot_wider(names_from = Condition, values_from = Positive_Cells)
#The same method is applied to the percentage of transfected cells with activated biosensor as was done in the "Integrated_Intensity" program.
#Afterwards the standard code as found in the normal SIRF_Cell_Profiler program is used.
write.csv(Cells_Transfected, "(Please use your own input directory)")
#Saves the new table
Processed_Data_Untransfected <- read.csv("(Please use your own input directory)") %>% select(1:3,7) %>% rename(Integrated_Intensity = Mean_Biosensor_Signal_Intensity_IntegratedIntensity_Biosensor_Signal_Masked) %>% 
mutate(Integrated_Intensity = ifelse(is.nan(Integrated_Intensity), 0, Integrated_Intensity))
#Data for untransfected cells only
Integrated_Intensity_Untransfected <- Processed_Data_Untransfected %>% group_by(ImageNumber) %>% summarize(Mean_Integrated_Intensity = mean(Integrated_Intensity, na.rm = TRUE))
Integrated_Intensity_Untransfected <- bind_cols(Conditions, Integrated_Intensity_Untransfected) %>% select(1,2,4)
Integrated_Intensity_Untransfected <- Integrated_Intensity_Untransfected %>% pivot_wider(names_from = Condition, values_from = Mean_Integrated_Intensity)
#Same code used in normal SIRF_Cell_Profiler program for untransfected cells
write.csv(Integrated_Intensity_Untransfected, "(Please use your own output directory)")
#Saves the new table.
Cells_Untransfected <- Processed_Data_Untransfected %>% filter(!is.nan(Children_Biosensor_Signal_Count))
Cells_Untransfected <- Cells_Untransfected %>% group_by(ImageNumber) %>% summarize(Positive_Cells = sum(Children_Biosensor_Signal_Count > 0)/length(Children_Biosensor_Signal_Count)*100)
Cells_Untransfected <- bind_cols(Conditions, Cells_Untransfected) %>% select(1,2,4)
Cells_Untransfected <- Cells_Untransfected %>% pivot_wider(names_from = Condition, values_from = Positive_Cells)
#Same code used in normal SIRF_Cell_Profiler program for untransfected cells
write.csv(Cells_Untransfected, "(Please use your own input directory)")
#Saves the new table.