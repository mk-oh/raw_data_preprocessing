#### Import Library
options(scipen = 999, stringsAsFactors = F)

library(readr) #read_csv
library(readxl)
library(data.table) #rbindlist()
library(dplyr) # select
library(reshape2)
library(tidyr) # fill
library(lubridate)
library(glue)

# Import Function for data import
source('0_function.R')

# Import Excel data(SAP Data)
source('1_raw_data_load.R')

# Data Preprocess (NA -> 0 , Define colnames)
source('2_data_preprocessing.R')

#
source('3_data_stack.R')



