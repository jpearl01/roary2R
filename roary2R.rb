#!/usr/bin/env ruby

require 'optimist'
require 'csv'


opts = Optimist::options do
  version "roary2R.rb 1.1 (c) 2020 Josh Earl"
  banner <<-EOS
This program converts Rachel's 'gene_presence_absence_paralogs_merged.csv'
Into a 'long' format for reading into R.  It also converts the long gene names
Back into short read names of the format "L_######_###" into "L_#####"
e.g. L_00105___23171 into L_00105 and adds that to the 'gene_short' column
while maintaining the original in the 'gene_long' column.

Usage: ruby roary2R.rb -r gene_presence_absence_paralogs_merged.csv -o output.csv

where [options] are:
EOS

  opt :r,   "Roary gene_presence_absence_paralogs_merged.csv file", 		:type => :string, :required => true
  opt :o,   "Output File Name", 		:type => :string, :required => true
  
end

headers=[]
all_strain_data = {}
cluster_count = 0

CSV.open(opts.r, 'r').each do |line|
	if $. == 1

		line.each do |e| 
			#Non friendly column names, boo!  Replace with underscores
			h = e.gsub(/\.? /, "_") 
			headers.push(h)
		end	

		(11..line.size-1).each do |e|
			all_strain_data[line[e]] = {}
		end

	else
		cluster_count = cluster_count + 1
		clust = "cluster_"+cluster_count.to_s
		#replace random commas with semicolons so we don't break csv format
		line.each do |e|
			e.gsub!(",",";")
		end

		(11..line.size-1).each do |e|

			#Instead of wasting time getting NA's in, just going to skip genes not present in the genome for now
			next unless line[e].size >0

			#Somteimes a strain has multiple genes in the cluster (i.e. the merged paralogs)
			#handle that case (probably only need to split on tabs, but just incase)
			if line[e].gsub(/[\s\t]+/m, ' ').split(" ").size >1
				
				line[e].gsub(/[\s\t]+/m, ' ').split(" ").each do |l|
					dat =  line[0..10].push(clust)
					dat << l.gsub(/(L_\d+)_+.+/,'\1')
					all_strain_data[headers[e]][l] = dat
				end

				#Otherwise there is just a single name, no need to iterate over the different versions
			else
				dat =  line[0..10].push(clust)
				dat << line[e].gsub(/(L_\d+)_+.+/,'\1')
				all_strain_data[headers[e]][line[e]] = dat
			end
		end

	end
end

out = File.open(opts.o, "w")

#create header
out.puts "strain,gene_long,"+headers[0..10].join(",") + ",cluster_id,gene_short"

#write out all the entries with their strain name 
all_strain_data.each_key do |s|
	all_strain_data[s].each do |l|
		out.puts s+","+l.join(",")
	end
end

#out.close
