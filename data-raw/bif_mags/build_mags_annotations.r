library(dplyr)


# correspondence between taxonomy and mags and samples
mags_tax = readr::read_tsv("Bifidobacterium_annotation/annotations_url_metadata_opendata.tsv") %>%
  filter(assigned_genus=="Bifidobacterium") %>%
  select(genome_name,study,sample_name,assigned_species,completeness)

# correspondence between mags and genes_id
mags_genes_id = readr::read_csv2("fna_headers.csv", col_names = FALSE) %>%
  mutate(genome_name = gsub(".fa.fna","",X1)) %>%
  rename(gene_id=X2) %>%
  select(genome_name,gene_id)

# correspondence between genes_id and representative genes_id cd_hit nr95
genes_id_cd_hit = readr::read_tsv("bif_clusters/all.bif.nr95.fna.rep.tsv")


# correspondence between representative genes_id and eggnog_id (seed_ortholog)
genes_id_rep_eggnog = readr::read_tsv("bif_clusters/bif.nr95.annot.emapper.annotations", comment = "##")

mags_tax_gene_id_eggnog =
mags_tax %>%
  merge(mags_genes_id, by="genome_name")

mags_tax_gene_id_eggnog =
  mags_tax_gene_id_eggnog %>%
  merge(genes_id_cd_hit %>% select(id_rep,id) , by.x="gene_id", by.y="id")

mags_tax_gene_id_eggnog =
  mags_tax_gene_id_eggnog %>%
  merge(genes_id_rep_eggnog %>% select(`#query`, seed_ortholog, EC, KEGG_ko, CAZy, Description), by.x="id_rep", by.y="#query")



mags_tax_gene_id_eggnog %>% write.csv2(file="mags_tax_gene_id_eggnog.csv")








