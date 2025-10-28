# Simple R script to copy a folder tree and clean filenames
# Input and output directories, customize as needed
input_dir <- "C:/RWorking/WWOL_Public"
output_dir <- "C:/RWorking/clean_WWOL_Public"

# Create output directory if it doesn't exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Function to clean names: replace anything not alphanumeric, dash, or dot with underscore
clean_name <- function(name) {
  gsub("[^A-Za-z0-9._-]", "_", name)
}

# Get all files (including subfolders)
files <- list.files(input_dir, recursive = TRUE, full.names = TRUE)

for (f in files) {
  # Determine relative path
  rel_path <- sub(paste0("^", gsub("\\\\", "/", input_dir), "/?"), "", gsub("\\\\", "/", f))
  
  # Split into parts to clean each folder and filename
  parts <- strsplit(rel_path, "/")[[1]]
  clean_parts <- sapply(parts, clean_name)
  clean_rel_path <- paste(clean_parts, collapse = "/")
  
  # Build output path
  dest_path <- file.path(output_dir, clean_rel_path)
  dest_dir <- dirname(dest_path)
  
  # Create directory if needed
  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE)
  }
  
  # Copy file (preserving binary content)
  file.copy(f, dest_path, overwrite = TRUE)
}

cat("All files copied with cleaned names! \n")


# Get all files (recursively)
files <- list.files(output_dir, recursive = TRUE, full.names = TRUE)

# Get file info (size, etc.)
info <- file.info(files)

# Filter for files larger than 99 MB
large_files <- info[info$size > 99 * 1024^2, , drop = FALSE]

# Show the paths and sizes in MB
if (nrow(large_files) > 0) {
  result <- data.frame(
    path = rownames(large_files),
    size_MB = round(large_files$size / 1024^2, 2)
  )
  print(result)
} else {
  cat("No files larger than 99 MB found! \n")
}