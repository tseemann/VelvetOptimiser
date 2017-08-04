---
title: 'Velvet Optimiser: automatic optimisation of Velvet assembly parameters'
tags:
  - bioinformatics
  - de novo assembly
authors:
 - name: Simon Gladman
   orcid: 0000-0002-6100-4385
   affiliation: Melbourne Bioinformatics, University of Melbourne
-  name: Andrew J Page
   orcid: 0000-0001-6919-6062
   affiliation: Pathogen Informatics, Wellcome Trust Sanger Institute
 - name: Torsten Seemann
   orcid: 0000-0001-6046-610X
   affiliation: Melbourne Bioinformatics, University of Melbourne
  
date: 27 Jul 2017
bibliography: paper.bib
---

# Summary

The Velvet assembler, like several other next generation sequencing assembly applications, assemble de novo millions of short reads using de Bruijn graphs (Zerbino and Birney 2008; Zerbino et al. 2009). A de Bruijn graph is a directed graph where nodes consist of overlapping sub-sequences of reads (k-mers).  After construction and simplification of the de Bruijn graph, contiguous DNA sequences (contigs) are "read off" the graph by tracing a set of paths in a determined order.  These contigs are the final output of the assembly and represent the partially assembled genome. The results that Velvet produces are very sensitive to user defined assembly parameters, especially the k-mer length, the coverage cutoff, and the expected coverage parameters.  There is no "best choice" or default settings for these parameters which gives an optimum assembly for all data sets.  Therefore, assemblies of different data sets must be optimized individually by many "trial and error" runs of Velvet.  The parameter space to be searched for the optimal assembly parameters can be quite large, requiring numerous and time consuming "trial and error" runs of Velvet, for optimization. In this paper we present Velvet Optimiser, a software tool written in Perl and bioperl, which automates the search through the parameter space for an optimum parameter set that will optimise one or two different assembly metrics, such as the N50 or number of bases in long contigs, to produce the “best” final draft assembly for the specific input dataset. The assembly metrics that are optimised can optionally be defined by the user. This software (originally written in 2009) is confirmed to have been used to assemble over 25% (23,372) of all prokaryotic genomes deposited in GenBank and the software repository has been cited more than 500 times in published articles including (Page et al. 2016; Wong et al. 2015; Chewapreecha et al. 2014).

# References
