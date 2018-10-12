#---DESC.
# 1. 기존 데이터 로드
# 2. 추가 SAP 데이터 Excel 파일 load, preprocessing 진행
# 3. 기존 데이터와 추가 데이터 병합 후 결측값 채움
# 4. 각 data frame RDS로 저장

### data road & setting
#sell_in_div <- readRDS("D:/project/order_raw_org/33-34week/sell_in_div.RDS")
load("D:/project/order_raw_org/32week/sell_in_total.Rdata")

sell_in_total <- readRDS("D:/project/order_raw_org/39week/sell_in_total.RDS")
tmp <- sell_in_total[!duplicated(sell_in_total), ]

time_tk_date <- readRDS("D:/2018_Rdata/time_tk/time_tk.RDS")
dir = "D:/project/order_raw_org/"
mm = "39week"

lf <- paste0(dir, mm, "/", list.files(paste0(dir, mm)))

df_list <- lapply(lf, ap_load)

brand_total <- rbindlist(df_list)
rm(df_list)
colnames(brand_total)[4:5] <- c("div", "cnt")

###############################################################################################
tmp_div <- div_df(brand_total) %>% unique() %>%
           mutate(div2 = gsub(" ", "", div2), div3 = gsub(" ", "", div3))

brand_total2 <- divide_div(brand_total)


#### Column namning ####
col.ap <- c("sell_in_cnt", "etc",
     "prom_ass_exc", "prod_lack", 
     "inv_lack", "mat_postpone",
     "order_error", "master_error",
     "ass_exc", "avail_inven", "inven_cnt")

colnames(brand_total2$all)[4:14] <- col.ap 
colnames(brand_total2$not_all)[4:15] <- c("div", col.ap)


#### Column namning ####
bt_t <-brand_total2$all %>% select(-c(avail_inven, inven_cnt))


bt_t <- rbindlist(bt_t) %>% filter(!grepl("수출", prod_nm)) %>% select(1, 3, 4, 13, 14, 15, 16, 17, 18, 19)
bt_df <- bt_t %>% filter(sell_in_cnt > 0) %>% .$prod_cd %>% unique()

bt_t <- lapply(bt_df ,
         total_fill_missing,
         df = bt_t) %>% filter(!(substr(prod_cd, 1, 5) %in% except_cd))


###############################################################################################
##stack
###############################################################################################
sell_in_total2 <- rbind(sell_in_total, bt_t) %>% 
  mutate_if(is.factor, as.character) %>%
  mutate_if(is.character, as.integer)

sell_in_total3 <- sell_in_total2[!duplicated(sell_in_total2), ]

#----. saveRDS
saveRDS(sell_in_total3, file = "D:/project/order_raw_org/39week/sell_in_total.RDS")