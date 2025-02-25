
#' @importFrom data.table %between% %chin% %flike% %ilike% %inrange% %like% address alloc.col as.data.table as.IDate as.ITime as.xts.data.table chgroup chmatch chorder CJ copy cube data.table dcast dcast.data.table fcoalesce fifelse fintersect foverlaps frank frankv fread frollapply frollmean frollsum fsetdiff fsetequal fsort funion fwrite getDTthreads getNumericRounding groupingsets haskey hour IDateTime indices inrange is.data.table isoweek key like mday melt melt.data.table merge.data.table minute month nafill quarter rbindlist rleid rleidv rollup rowid rowidv second set setalloccol setattr setcolorder setDF setDT setDTthreads setindex setindexv setkey setkeyv setnafill setnames setNumericRounding setorder setorderv shift shouldPrint SJ tables test.data.table timetaken transpose truelength tstrsplit uniqueN wday week yday year
#' @importFrom stats na.omit reorder


globalVariables(c("token","keyword_most","name","freq","keywords",
                  "group","keyword","value","keyword_value","id2",
                  "Group","stop_words","dt","df","stopword_vector",
                  "item1","item2"))

globalVariables(c(":=","!!",".",".SD"))
