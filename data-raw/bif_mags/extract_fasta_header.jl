#!/usr/bin/julia
# Extract all fasta headers of faa files



# Define packages and functions

## Load FASTX
using FASTX

## Define function for directory search of a keyword
searchdir(path, key) = filter(x -> occursin(key, x), readdir(path))

# Define file locations
in_dir = "bif_clusters/"
outfile = open("fna_headers.csv", "w")

# Do the extraction
for file in searchdir(in_dir, ".fa.fna")

        reader = open(FASTA.Reader, string(in_dir, file))

        for seq in reader
                identifier = FASTA.identifier(seq)
                #description = FASTA.description(seq)
                #write(outfile, string(file, ";", identifier, ";", description, "\n"))
                write(outfile, string(file, ";", identifier, "\n"))
        end

        close(reader)

end

close(outfile)
