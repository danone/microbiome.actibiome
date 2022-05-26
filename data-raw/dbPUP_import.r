# import dbPUP db from
# https://github.com/pengxiangzhang/Yin-Lab-dbPUP/blob/main/db/bo.sql.zip

# in unix terminal
# grep GUT_GENOME bo.sql | grep "'MAG'" > MAG_GUT_GENOMES_dbPUP.annot

# in R
#   dbPUP = readLines("MAG_GUT_GENOMES_dbPUP.annot")
#   data.frame(dbPUP=dbPUP) %>% tidyr::separate(dbPUP, into=LETTERS, sep="',") %>% select(A,J,B,E) %>% tidyr::separate(A, into=c("idx","A") , sep="," )   %>% mutate(J= gsub("\\'\\)\\,","",J) %>% gsub("'","",.) %>% gsub("\\)\\;","",.) ) -> dbPUP_clean
#   readr::write_tsv(dbPUP_clean, file="dbPUP_clean.tsv")


