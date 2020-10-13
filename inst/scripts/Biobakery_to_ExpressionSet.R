## Input datasets
fpath <- "gs://fc-07ee4ddc-5b5b-46f6-bed7-809aa14bb012/IBDMDB/ibdmdb_file_list.txt"
inputs <- read.table(gsutil_pipe(fpath), sep = "\t")
sampleName <- gsub("_R1.fastq.gz", "", basename(inputs$V1))



## Setup the directory structure
dataset_name <- "test"
dat_dir <- file.path("data", dataset_name)
if (!dir.exists(dat_dir)) dir.create(dat_dir)
dir_list <- c("genefamilies_relab", "marker_abundance", "marker_presence", "metadata", 
              "metaphlan_bugs_list", "pathabundance_relab", "pathcoverage")
    for (i in seq_along(dir_list)) {
  target_dir <- file.path(dat_dir, dir_list[i])
  if (!dir.exists(target_dir)) {dir.create(target_dir)}
}



## Copy outputs to the proper directories
avworkspace_namespace("waldronlab-terra-rstudio")
avworkspace_name("mtx_workflow_biobakery_ver3")
outputs <- avworkflow_files()

for (i in seq_along(dir_list)) {
  ind <- grep(dir_list[i], outputs$file)
  for (j in ind) {
    gsutil_cp(outputs$path[j], 
              destination = file.path(dat_dir, dir_list[i]))
  }
}