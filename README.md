## Actibiome

This readme will describe each RMD file and their purpose.
The user may execute the code in the same order as this file.


---- functions.R			input

					- functions useful for all scripts
					- functions for processinng phyloseq objects

					output


- curated_v3_otu_tax.rda : the CMD raw data.


---- Projet-1.Rmd			input	 curated_v3_otu_tax.rda 

					- filtering the CMD data
					- basic exploratory/statistical analyses

					output	 study_after_QC.rda


- study_after_QC.rda : CMD filtered data.


---- Heatmaps.Rmd			input	 curated_v3_otu_tax.rda

					- heatmaps accross host factors

					output


---- run_spiec_easi_analyse.Rmd		input	 study_after_QC.rda

					- Bifidobacterium network analyses

					output 	phy_curated_data_after_QC.rda
						phy_deseq_analysis_150


- phy_curated_data_after_QC.rda : CMD filtered data (phyloseq objects)
- phy_deseq_analysis_150 : CMD filtered data with 150 most abundant otu (phyloseq objects)



---- DMM_clustering.Rmd		input	study_after_QC.rda
					phy_curated_data_after_QC.rda

					- DMM clustering and all descriptive clusters
					- when running, choose whole curated for origin CMD bifidotypes

				output enterotype_DMM
					all files created in DMM_files folder


- enterotype_DMM : contaning the CMD bifidotypes


---- differential_analysis.Rmd		input	phy_deseq_analysis_150
						enterotype_DMM

					- DMM clustering and all descriptive clusters

					output


- data-raw : alias of data-raw folder



---- MAGS_analysis.Rmd		input	all input are located in data-raw

					- MAGs analyses :
					- inter/intra species heatmaps

				output


---- bif_rda_analysis.Rmd	input	inputs are located in data-raw
					enterotype_DMM

					- MASH analyses with bifidotypes X 15 phage eggnogs associated

				output



---- eggnogs_MAGS.Rmd		input 	are located in data-raw
					curated_v3_otu_tax.rda
					enterotype_DMM

					- all the Chisquare analyses
					- interspecies and with unhealthy/healthy bifidotypes

				output all the association files

- test : contains IGC.egg5.0.tsv
- IGC.eggNOG_v5.0.tsv : MSP EggNOG composition
- association_eggnogs_metadata_grp_healthy.csv : eggnog X bifidotypes association
- association_eggnogs_metadata_age_category.csv : eggnog X age association
- association_eggnogs_metadata_westernized.csv : eggnog X westernized association
- association_species_species.csv : eggnog species X eggnog other species  association

MI_metadata_extraction.xlsx : metadata MI
sample_metadata_msp.xlsx : metadata MI


---- MSP_analysis.Rmd		input 	are located in data-raw
					IGC.eggNOG_v5.0.tsv
					curated_v3_otu_tax.rda
					DMM_files/best_fit_DMM_6clusters
					MI_metadata_extraction.xlsx
					sample_metadata_msp.xlsx

					- predict the bifidotypes
					- of milieu interieur based on CMD 6 clusters
					- Shannon diversity

				output



---- DMM_MSP.Rmd		input 	are located in data-raw
					IGC.eggNOG_v5.0.tsv
					curated_v3_otu_tax.rda
					DMM_files/best_fit_DMM_6clusters
					association_eggnogs_metadata_grp_healthy.csv
					MI_metadata_extraction.xlsx
					sample_metadata_msp.xlsx

					- de novo DMM clustering on DMM
					- explorative analyses with diet factors
					- diversity, age, CRP, nutritional factors

				output


---- MI_MSP_exploration.Rmd	input 	are located in data-raw
					IGC.eggNOG_v5.0.tsv
					curated_v3_otu_tax.rda
					DMM_files/best_fit_DMM_6clusters
					association_eggnogs_metadata_grp_healthy.csv

					- predict the bifidotypes
					- of milieu interieur based on CMD 6 clusters
					- test the prevalence of the 4 phage eggnogs

				output  df_healthy_msp.csv

- df_healthy_msp.csv : heatmap MSP X Subjects : contains the counts of 4 phage eggnogs (B. bifidum)


---- MI_MSP_exploration_simplified.Rmd		input 	are located in data-raw
							sample_metadata_msp.xlsx
							MI_metadata_extraction.xlsx
							df_healthy_msp.csv

							- predict the bifidotypes
							- of milieu interieur based on CMD 6 clusters
							- test the prevalence of the 4 phage eggnogs

						output


