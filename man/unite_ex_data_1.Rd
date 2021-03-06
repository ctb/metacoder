% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataset_documentation.R
\name{unite_ex_data_1}
\alias{unite_ex_data_1}
\title{Example of UNITE fungal ITS data}
\format{An object of type \code{\link{taxmap}}}
\source{
\url{https://unite.ut.ee/}
}
\description{
A dataset containing information from 449 sequences from the UNITE reference database.
}
\examples{
\dontrun{

file_path <- system.file("extdata", "unite_general_release.fasta", package = "metacoder")
sequences <- ape::read.FASTA(file_path)
headers <- names(sequences[!grepl(pattern = "\\\\|UDB", names(sequences))])
unite_ex_data_1 <- extract_tax_data(headers,
                                    regex = "^(.*)\\\\|(.*)\\\\|(.*)\\\\|.*\\\\|(.*)$",
                                    key = c(name = "info", "seq_id",
                                            other_id = "info", tax_string = "info"),
                                    database = "ncbi")
}

}
\seealso{
Other example_datasets: \code{\link{bryophytes_ex_data}},
  \code{\link{contaminants}},
  \code{\link{genbank_ex_data}},
  \code{\link{its1_ex_data}}, \code{\link{pr2_ex_data}},
  \code{\link{silva_ex_data}},
  \code{\link{unite_ex_data_2}}
}
