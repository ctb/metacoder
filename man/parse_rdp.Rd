% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parsers.R
\name{parse_rdp}
\alias{parse_rdp}
\title{Parse RDP FASTA release}
\usage{
parse_rdp(file, include_seqs = TRUE, add_species = FALSE)
}
\arguments{
\item{file}{(\code{character} of length 1) The file path to the input file.}

\item{include_seqs}{(\code{logical} of length 1) If \code{TRUE}, include 
sequences in the output object.}

\item{add_species}{(\code{logical} of length 1) If \code{TRUE}, add the
species information to the taxonomy. In this databse, the speceis name
often contains other information as well.}
}
\value{
\code{\link{taxmap}}
}
\description{
Parses an RDP reference FASTA file that can be found at
https://rdp.cme.msu.edu/misc/resources.jsp.
}
\details{
The input file has a format like:

\preformatted{
>S000448483 Sparassis crispa; MBUH-PIRJO&ILKKA94-1587/ss5	Lineage=Root;rootrank;Fun...
ggattcccctagtaactgcgagtgaagcgggaagagctcaaatttaaaatctggcggcgtcctcgtcgtccgagttgtaa
tctggagaagcgacatccgcgctggaccgtgtacaagtctcttggaaaagagcgtcgtagagggtgacaatcccgtcttt
...
}
}
\seealso{
Other parsers: \code{\link{parse_greengenes}},
  \code{\link{parse_mothur_tax_summary}},
  \code{\link{parse_mothur_taxonomy}},
  \code{\link{parse_newick}}, \code{\link{parse_phyloseq}},
  \code{\link{parse_qiime_biom}},
  \code{\link{parse_silva_fasta}},
  \code{\link{parse_unite_general}}
}
