#! /usr/bin/Rscript --vanilla

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#

# Rscript --vanilla mags_analysis.r

library(dplyr)

Bifidobacterium_bins = list.files("Bifidobacterium_bins", pattern = "*.fa")

#Bifidobacterium_bins = Bifidobacterium_bins[1:100] # to test


for(i in seq_along(Bifidobacterium_bins)){

  mags_input_path = paste0("Bifidobacterium_bins/",Bifidobacterium_bins[i])

  mags_prodigal_output = "bif_clusters/"


  prodigal_cmd = paste0("prodigal -i ",mags_input_path,
                        " -o ", paste0(mags_prodigal_output,Bifidobacterium_bins[i],".genes"),
                        " -a ", paste0(mags_prodigal_output,Bifidobacterium_bins[i],".faa"),
                        " -d ", paste0(mags_prodigal_output,Bifidobacterium_bins[i],".fna"))
  system(prodigal_cmd)



}


#Bifidobacterium_bins = Bifidobacterium_bins[1:3]

# mags_genes_id_df = data.frame(mags=NULL, genes_id=NULL)
#
# pb = txtProgressBar(min = 0, max = length(Bifidobacterium_bins), initial = 0)
#
# for(i in seq_along(Bifidobacterium_bins)){
#
#   mags_input_path = paste0("Bifidobacterium_bins/",Bifidobacterium_bins[i])
#
#   mags_prodigal_output = "bif_clusters/"
#
#   system(paste0("grep '^>' ", paste0(mags_prodigal_output,Bifidobacterium_bins[i],".fna"), " | cut -f 1 -d ' ' "), intern=TRUE) %>%
#     gsub("^>","",.) -> genes_id
#
#   mags_genes_id_df = rbind(mags_genes_id_df, data.frame(mags=Bifidobacterium_bins[i], genes_id=genes_id))
#
#   setTxtProgressBar(pb,i)
#
# }
# close(pb)
#
# readr::write_tsv(mags_genes_id_df, file = "bif_clusters/mags_genes_id.tsv")

system("./extract_fasta_header.jl") #output : fna_headers.csv



merge_fna_cmd = system("cat bif_clusters/*fa.fna > bif_clusters/all.bif.fna")



cd_hit_est_cmd = "cd-hit-est -aS 0.9 -c 0.95 -T 0 -M 0 -t 0 -d 100 -G 0 -i bif_clusters/all.bif.fna -o bif_clusters/all.bif.nr95.fna"

system(cd_hit_est_cmd)

system("./clstr2txt.pl bif_clusters/all.bif.nr95.fna.clstr > bif_clusters/all.bif.nr95.fna.tsv")


all_bif_cd_hit = readr::read_tsv("bif_clusters/all.bif.nr95.fna.tsv")

all_bif_cd_hit %>%
  #head(50) %>%
  dplyr::filter(clstr_rep == 1) %>%
  dplyr::select(id,clstr) %>%
  dplyr::rename(id_rep=id) -> all_bif_cd_hit_rep

all_bif_cd_hit %>%
  #head(50) %>%
  merge(all_bif_cd_hit_rep, ., by="clstr") -> all_bif_cd_hit_rep


readr::write_tsv(all_bif_cd_hit_rep, file="bif_clusters/all.bif.nr95.fna.rep.tsv")


#emapper_cmd = "python3.7 /home/tapju/bin/eggnog-mapper/emapper.py -m hmmer -d Actinobacteria --itype CDS --translate -i bif_clusters/all.bif.nr95.fna -o bif_clusters/bif.nr95.annot --cpu 16"
#emapper_cmd = "python3.7 /home/tapju/bin/eggnog-mapper/emapper.py --itype CDS --translate -i bif_clusters/all.bif.nr95.fna -o bif_clusters/bif.nr95.annot --cpu 16"
#system(emapper_cmd)

#run_dbcan /home/tapju/storage/actibiome/data-raw/bif_mags/bif_clusters/all.bif.nr95.fna prok --out_dir /home/tapju/storage/actibiome/data-raw/bif_mags/output_bif_dbcan
# nohup run_dbcan /home/tapju/storage/actibiome/data-raw/bif_mags/bif_clusters/all.bif.nr95.fna prok --out_dir /home/tapju/storage/actibiome/data-raw/bif_mags/output_bif_dbcan3 --db_dir /opt/dbcan/db &
