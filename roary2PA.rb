#!/usr/bin/env ruby

require 'optimist'
require 'csv'


opts = Optimist::options do
  version "roary2PA.rb 1.1 (c) 2020 Josh Earl"
  banner <<-EOS
This program converts Rachel's 'gene_presence_absence_paralogs_merged.csv'
into a pure presence/absence matrix for each gene (i.e. just a 1 if any number of genes/paralogs,  0 otherwise)
converts to a tab separated files, because there are commas in some of the cells

Usage: ruby roary2PA.rb -r gene_presence_absence_paralogs_merged.csv -o output.tsv

where [options] are:
EOS

  opt :r,   "Roary gene_presence_absence_paralogs_merged.csv file", 		:type => :string, :required => true
  opt :o,   "Output File Name (output.tsv)", 		:type => :string, :default => "output.tsv"
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
		
		out.puts headers.join("\t") + "\tcluster_id"
		
	else
		cluster_count = cluster_count + 1
		clust = "cluster_"+cluster_count.to_s
		(0..11).each do |e|
			line[e].gsub!("\t", ",")
		end
		
		(11..line.size-1).each do |e|	
			#Check if there is nothing in the cell, if so it is 0, 1 otherwise
			line[e] = line[e] == '' ? 0 : 1

		end

	end

	out.puts(line.join("\t") + "\t" + clust) unless $. == 1

end	

