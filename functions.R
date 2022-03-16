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