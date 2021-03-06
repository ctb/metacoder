% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parsers.R
\name{parse_qiime_biom}
\alias{parse_qiime_biom}
\title{Parse a BIOM output from QIIME}
\usage{
parse_qiime_biom(file)
}
\arguments{
\item{file}{(\code{character} of length 1) The file path to the input file.}
}
\value{
A taxmap object
}
\description{
Parses a file in BIOM format from QIIME into a taxmap object.
I have not tested if it works with other BIOM files.
}
\details{
This function was inspired by the tutorial created by Geoffrey Zahn at 
http://geoffreyzahn.com/getting-your-otu-table-into-r/.
}
\seealso{
Other parsers: \code{\link{parse_greengenes}},
  \code{\link{parse_mothur_tax_summary}},
  \code{\link{parse_mothur_taxonomy}},
  \code{\link{parse_newick}}, \code{\link{parse_phyloseq}},
  \code{\link{parse_rdp}}, \code{\link{parse_silva_fasta}},
  \code{\link{parse_unite_general}}
}
