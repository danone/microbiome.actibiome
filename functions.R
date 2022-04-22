

merge_samples_mean <- function(physeq, group){
  "This function allow to merge samples from a phyloseq object by a category by doing the mean of samples in each category"
  
  # Return new phyloseq object with taxa as rows
  
  group_sums <- as.matrix(table(sample_data(physeq)[ ,group]))[,1]
  
  # Merge samples by summing
  
  # Divide summed OTU counts by number of samples in each group to get mean
  
  merged <- merge_samples(physeq, group)
  
  # Calculation is done while taxa are columns, but then transposed at the end
  
  x <- as.matrix(otu_table(merged))
  
  
  if(taxa_are_rows(merged)){ x<-t(x) }
  
  out <- t(x/group_sums)
  
  # Return new phyloseq object with taxa as rows
  
  out <- otu_table(out, taxa_are_rows = TRUE)
  
  otu_table(merged) <- out
  
  return(merged)
}

########################################

transform_westernized <- function(map){
  
  map <- map %>%
    mutate(., westernized =
             case_when(non_westernized == 'yes' ~ "no",
                       non_westernized == 'no' ~ "yes"))
  
  return (map)
  
}

transform_disease <- function(map){
  

  map$disease <- factor(map$disease)

  # tout d'abord on simplifie les facteurs car il y a en a 23

  # tous les facteurs contenant "adenoma" :
  Adenoma <- grep("adenoma", levels(map$disease),fixed=TRUE,state.name, value = TRUE)

  # tous les facteurs contenant "CRC" :
  Colorectal <- c("metastases",grep("CRC", levels(map$disease),fixed=TRUE,state.name, value = TRUE))

  # les maladies métaboliques (T2D, hypercholestérolémie etc etc)

  Metabolic <- c("ACVD", "hypercholesterolemia", "hypertension", "hypertension;metastases", "IGT", "T2D")

  # enfin le bipolar disorder et 

  Bowel <- c("IBD")

  Arthritis <- c("RA")

  levels(map$disease) = list(
    "Control" = c("healthy"),
    "Adenoma" =  Adenoma,
    "Colorectal" = Colorectal,
    "Metabolic" = Metabolic,
    "Bowel" = Bowel,
    "Arthritis" = Arthritis,
    "BD" = c('BD'))

  return(map)

}


########################################


species_taxa <- function(phy){
  "This function allows to get the species of a list of taxanames in a phy object"
  data <- data.frame(phy@tax_table)
  
  return(data$Species)
}


select_n_otu <- function(n, tableau_otu) {
  "Select les n otu les plus abondants dans un fichier otu"
  
  prevalence <- tableau_otu %>%
    t(.) %>%
    data.frame(.) %>%
    summarise_all(., funs(mean(.>0))) %>%
    t(.) %>%
    data.frame(.) %>%
    arrange(desc(.)) %>%
    slice(1:n)
  
  rownames(prevalence) <- gsub("\\.", "\\|", rownames(prevalence))
  
  return(rownames(prevalence))
  
}

########################################


subset_bifid_non_bifid <- function(n, m, otu, tax){
  #"select les m espèces bifid, et n espèces non bifid les plus prévalentes dans tous les groupes de la table otu"

  
  tax <- as.data.frame(tax)
  
  otu <- as.data.frame(otu)
  
  especes <- tax %>%
    select(Species, Genus)
  
  
  # les bifids
  
  les_bifid <- especes %>%
    filter(Genus == "Bifidobacterium")
  
  bifid_otu <- otu %>%
    filter(rownames(.) %in% rownames(les_bifid))

  
  m_bifid <- select_n_otu(m, bifid_otu)
  
  # les non bifids
  
  non_bifid <- especes %>%
    filter(Genus != "Bifidobacterium")
  
  n_bifid <- otu %>%
    filter(rownames(.) %in% rownames(non_bifid))
  
  n_non_bifid <- select_n_otu(n, n_bifid)
  
  
  
  n_non_bifid <- gsub("\\.", "\\|", n_non_bifid)
  
  m_bifid <- gsub("\\.", "\\|", m_bifid)
  
  return(c(n_non_bifid, m_bifid))
}

#lll <- subset_bifid_non_bifid(10,20,otus,tax)


#####################################################"
## get species

## get species d'une table otu

get_species <- function(tax,liste_taxa){
  "Renvoie la liste des espèces à partir d'une liste de taxa"
  
  tax_t <- tax %>%
    rownames_to_column("taxa")
  
  taxa <- data.frame(taxa=liste_taxa)
  
  names <- taxa %>%
    left_join(.,tax_t, by="taxa") %>%
    select(Species)
  
  return(as.character(names$Species))
  
}

get_bifid <- function(tax,liste_taxa){
  "Renvoie la liste des bifid/nonbifid à partir d'une liste de taxa"
  
  tax_t <- tax %>%
    rownames_to_column("taxa") %>%
    mutate(Genus =
             case_when(Genus == 'Bifidobacterium' ~ "Bifidobacterium", 
                       TRUE ~ "Other Genus"))
  
  taxa <- data.frame(taxa=liste_taxa)
  
  names <- taxa %>%
    left_join(.,tax_t, by="taxa") %>%
    select(Genus)
  
  return(as.character(names$Genus))
  
}

get_bifid_species <- function(tax,liste_taxa){
  "Renvoie la liste des bifid/nonbifid à partir d'une liste d'espèces"
  
  tax_t <- tax %>%
    rownames_to_column("taxa") %>%
    mutate(Genus =
             case_when(Genus == 'Bifidobacterium' ~ "Bifidobacterium", 
                       TRUE ~ "Other Genus"))
  
  taxa <- data.frame(Species=liste_taxa)
  
  names <- taxa %>%
    left_join(.,tax_t, by="Species") %>%
    select(Genus)
  
  return(as.character(names$Genus))
  
}



