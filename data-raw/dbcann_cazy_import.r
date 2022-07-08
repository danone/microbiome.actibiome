

  readr::read_tsv("data-raw/bif_mags/output_bif_dbcan3/overview.txt") %>%
  filter(`#ofTools` == 3) %>%
  mutate(`Gene ID` = `Gene ID` %>% stringr::str_sub(end=-3)) %>%
  select(`Gene ID`, eCAMI) %>%
  dplyr::rename(cazy_family=eCAMI) %>%
  readr::write_tsv(file="data-raw/cazy_dbcann.tsv")


