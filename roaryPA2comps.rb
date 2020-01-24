#!/usr/bin/env ruby

require 'optimist'
require 'csv'
require 'daru'

#This program converts a tab separated roary gene presence/absence table (from roary2PA.rb)
#Into a matrix of pairwise comparisons between strain presence/absences

#usage: ruby roary2R.rb -r gene_presence_absence_paralogs_merged.csv -o output.tsv



opts = Optimist::options do
  opt :r,   "Roary gene_presence_absence_paralogs_merged.csv file", 		:type => :string, :required => true
  opt :o,   "Output File Name (output.tsv)", 		:type => :string, :default => "output.tsv"
end