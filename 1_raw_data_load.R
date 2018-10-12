#---DESC.

# 1. 최초 SAP 데이터로 적재한 Excel 파일에 대한 Import 수행 
# 2. List로 Import 된 데이터에 대한 병합 수행

#### data Import
setwd("D:/order_raw/tmp")
data.dir <- "D:/order_raw/tmp" # + /hera, /sulwhasoo, /primera, /liri, /ap folder
data.subdir <- c("h", "s", "v", "p", "l", "a") 
data.dir2 <- glue('{data.dir}/{data.subdir}/')# Setting folder name

#### AP change colnm
brd_list <- list() # make temp list
i=6
for(i in 1:length(data.subdir)) {
  ap_file <- data.dir2[i] %>% dir
  df_list <- lapply(paste0(data.dir2[i],ap_file), ap_load)
  brd_list[[i]] <- rbindlist(df_list)
  colnames(brd_list[[i]])[4:5] <- c("div","cnt")
}

saveRDS(brd_list, file="D:/project/order_raw/tmp/tmp.RDS")
