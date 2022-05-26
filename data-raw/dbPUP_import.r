# import dbPUP db from
# https://github.com/pengxiangzhang/Yin-Lab-dbPUP/blob/main/db/bo.sql.zip

# in unix terminal
# grep GUT_GENOME bo.sql | grep "'MAG'" > MAG_GUT_GENOMES_dbPUP.annot

# in R
#   dbPUP = readLines("MAG_GUT_GENOMES_dbPUP.annot")
#   data.frame(dbPUP=dbPUP) %>% tidyr::separate(dbPUP, into=LETTERS, sep="',") %>% select(A,J,B,E) %>% tidyr::separate(A, into=c("idx","A") , sep="," )   %>% mutate(J= gsub("\\'\\)\\,","",J) %>% gsub("'","",.) %>% gsub("\\)\\;","",.) ) -> dbPUP_clean
#   readr::write_tsv(dbPUP_clean, file="dbPUP_clean.tsv")


dbPUP %>% # from dbPUP_clean.tsv
  mutate(A = gsub("'","",A) ) %>% # clean a bit
  merge(bif_pup, by.x="A", by.y = "X2") %>% # merge with bif diamond hit
  merge(bif_length, by="X1") %>% #merge with gene length
  mutate(ll=(X4*3)/X2) %>% filter(X3>50, ll>0.5) %>% # select id=50% over 50% protein alignment
  group_by(X1,J) %>% top_n(n = 1, wt = X12) %>% # select top 1 by hit and by pup family
  dplyr::rename(id_rep=X1, pup_mag_gene=A, pup_family=J, tax=E, annot=B) %>%
  select(id_rep, pup_mag_gene, pup_family, tax, annot) %>%
  readr::write_tsv(file="data-raw/all.bif.nr95.dbPUP.hits.tsv")





