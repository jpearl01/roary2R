roary2R

Convert a matrix of gene presence/absence data into long format.

This will include strain names, gene names, cluster name, annotation etc.

This is handy for doing things in the R Tidyverse

roary2PA.rb

Converts the roary output of gene names per strain into a 1/0 matrix. Also adds a 'cluster_id' to the table, which is just a slightly easier string to work with instead of the insane R group names (these can be very long and difficult to parse)

roaryPA2comps.rb

Converts the outputs of roary2PA.rb into two matrices.  Similarity is the count of the number of genes two strains have in common. Difference is the number of genes not shared between two strains
