#!/usr/bin/env ruby

require 'trollop'
require 'csv'

#This program converts Rachel's 'gene_presence_absence_paralogs_merged.csv'
#into a pure presence/absence matrix for each gene (i.e. just a 1 if any number of genes/paralogs,  0 otherwise)

#usage: ruby roary2R.rb -r gene_presence_absence_paralogs_merged.csv -o output.csv



opts = Trollop::options do
  opt :r,   "Roary gene_presence_absence_paralogs_merged.csv file", 		:type => :string, :required => true
  opt :o,   "Output File Name", 		:type => :string, :required => true
end

headers=[]
all_strain_data = {}
cluster_count = 0
clust = ''

out = File.open(opts.o, "w")

CSV.open(opts.r, 'r').each do |line|
	if $. == 1

		line.each do |e| 
			#Non friendly column names, boo!  Replace with underscores
			h = e.gsub(/\.? /, "_") 
			headers.push(h)
		end	
		
		out.puts headers.join(",") + ",cluster_id"
		
	else
		cluster_count = cluster_count + 1
		clust = "cluster_"+cluster_count.to_s
		
		(11..line.size-1).each do |e|	

			line[e] = line[e] =='' ? 0 : 1
		end

	end

	out.puts(line.join(",") + clust)

end	

