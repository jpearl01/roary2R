#!/usr/bin/env ruby

require 'optimist'
require 'csv'
require 'daru'

#This program converts a tab separated roary gene presence/absence table (from roary2PA.rb)
#Into two matrices of pairwise comparisons between strain presence/absences

#usage: ruby roary2R.rb -r output.tsv

opts = Optimist::options do
  opt :r,   "Presence/Absence file output from roary2PA.rb", 		type: :string, required: true
  opt :s,   "Similarity Output File Name (output.tsv)", 		    type: :string, default: "similarity.tsv"
  opt :d,   "Difference output file name (difference.tsv)",     type: :string, default: "difference.tsv"
end

df = Daru::DataFrame.from_csv(opts[:r], col_sep: "\t")
pa = df[11..df.shape[1]-2]
sim_df = Daru::DataFrame.new([], order: pa.vectors, index: pa.vectors)
dif_df = Daru::DataFrame.new([], order: pa.vectors, index: pa.vectors)

#pa.write_csv("debug.tsv")
#abort()

#There may be a more 'daru' way to do this, but this works
(0..pa.shape[1]-1).each do |i|
	(0..pa.shape[1]-1).each do |j|
		new_vec = pa[i] + pa[j]
		diff = 0
		sim  = 0
		new_vec.each do |v|
			diff += 1 if v==1
			sim  += 1 if v==2
		end
		sim_df[i][j] = sim
		dif_df[i][j] = diff		
	end
	
end

sim_df.write_csv(opts[:s], col_sep: "\t")
dif_df.write_csv(opts[:d], col_sep: "\t")