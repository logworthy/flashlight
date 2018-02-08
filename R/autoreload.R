library(futile.logger)
install.packages('Rserve')
library(Rserve)
install.packages('RSclient')
library(RSclient)

# start server
# connect to server
# start code watch reload job
# when reload triggers
# kill & restart app

foo <- Rserve(port=24601, wait=F)
bar <- RS.connect(port=24601)
RS.close(bar)

stopApp()

# watch for changes to any file in a given folder + subs
watch <- function(root) {

  # get list of files
  gen_filenames <- function() {
    list.files(root, recursive=T, include.dirs=F, full.names =T)
  }

  # get modification times for files
  check_files <- function() {
    files <- sort(gen_filenames())
    structure(file.mtime(files), .Names=files)
  }

  # checking loop
  # TODO:  break the loop?
  last_result <- check_files()
  while(T) {
    result <- check_files()
    if(!identical(result, last_result)) {
      last_result <- result
      flog.info('File change detected, reloading...')
    }
    Sys.sleep(1)
  }

}

