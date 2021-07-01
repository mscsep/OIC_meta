# Meta-analysis of the rodent object-in-context task: Get flowchart numbers
# Written by Milou Sep

rm(list=ls())
library(dplyr)
library(osfr) # to interact with Open Science Framework
# instructions: https://github.com/CenterForOpenScience/osfr
# Authenticate to OSF (see: http://centerforopenscience.github.io/osfr/articles/auth.html). Via osf_auth("PAT") in the commentline. (note PAT can be derived from OSF)
library(readxl)


# retrieve OSF files ------------------------------------------------------
#search hits
osf_retrieve_file("dvwhn") %>% osf_download(path = "data", conflicts="overwrite") # search hits search string thesis MV
osf_retrieve_file("umz5k") %>% osf_download(path = "data", conflicts="overwrite") # search hits new search string (25.5.20)
# Screening
osf_retrieve_file("j7sfm") %>% osf_download(path = "data", conflicts="overwrite") # screening search string thesis MV
osf_retrieve_file("bz3sj") %>% osf_download(path = "data", conflicts="overwrite") # screening new search string
# data extraction file
osf_retrieve_file("qadch") %>% osf_download(path = "data", conflicts="overwrite")

# Load data ---------------------------------------------------------------
# search documents (PMID's)
search1.thesis <- read.table("data/hits.search.thesis.MV.txt",  quote="\"", comment.char="")
search2.meta <- read.table("data/hits.new.search.meta.oic.v25.5.20.txt",  quote="\"", comment.char="")
# screening documents
screeing.search1 <-read.csv2("data/Screening S1 thesis search PMIDs.csv", na.strings = c(""))
screeing.search2 <-read.csv2("data/Screening S2 new.in.new.search.PMIDs.csv", na.strings = c(""))
# data extraction file
read_excel("data/280121_Data_Extraction_RoB.xlsx", sheet = "Extraction_converted", na=c("N/A", "#VALUE!"))->data


# Compare PMIDs -----------------------------------------------------------
search1.thesis$V1[!search1.thesis$V1 %in% search2.meta$V1]-> not.in.new
search2.meta$V1[!search2.meta$V1 %in% search1.thesis$V1]->new.in.new
search2.meta$V1[search2.meta$V1 %in% search1.thesis$V1]->old.in.new

# Count hits and screened papers
nrow(search2.meta) #253
nrow(search1.thesis) # 54
nrow(screeing.search1) #  54
length(new.in.new) #219
nrow(screeing.search2) # 219 (so correct)
length(not.in.new) # 20
length(old.in.new) # 34
#new in new + old in new
219+34 # =253
# not in new + old in new
20+34 # = 54


# Counts for Flowchart ----------------------------------------------------
# Total
screeing.search1 %>% filter(PMID %in% old.in.new) %>% nrow()#  34
screeing.search2 %>% filter(PMID %in% new.in.new) %>% nrow() # 219
34+219 #= 253


# Counts search 1 (thesis) ------------------------------------------------
# str(screeing.search1)

screeing.search1 %>% 
  filter(PMID %in% old.in.new) %>% 
  filter(inclusie_july2020 == "yes") %>% nrow() # 30 included 

screeing.search1 %>% 
  filter(PMID %in% old.in.new) %>% 
  filter(full.text.checked.july2020 == "no") %>% #nrow()# 26
  filter(inclusie_july2020 == "yes") %>% nrow()# 26 included without full text check

screeing.search1 %>% 
  filter(PMID %in% old.in.new) %>%
  filter(full.text.checked.july2020 == "yes") %>% #nrow()# 8 full text checked
  filter(inclusie_july2020 == "yes") # of that 4 included (so 4 excluded)

screeing.search1 %>% 
  filter(PMID %in% old.in.new) %>% 
  filter(inclusie_july2020 == "no?" | inclusie_july2020 == "no") # 4 excluded (reason for all: no OIC)


# Counts search 2 (new) ---------------------------------------------------
# str(screeing.search2)

#total
screeing.search2 %>% filter(PMID %in% new.in.new) %>%
  filter(final.inclusion.screening == "Yes") %>% nrow() # 10 included

#included without full text check
screeing.search2 %>% filter(PMID %in% new.in.new) %>% #View()
  filter(full.text.checked.MS == "no") %>% #nrow()# 140 full text NOT checked
  filter(final.inclusion.screening == "Yes") # of that 10 included   

# excluded without full text check in s2 (+ reasons for exclusion)
screeing.search2 %>% filter(PMID %in% new.in.new) %>% #View()
  filter(full.text.checked.MS == "no") %>% 
  filter(final.inclusion.screening == "No") %>% #nrow()# 130
  mutate(Reason.for.exclusion = factor(Reason.for.exclusion))%>%
  select(Reason.for.exclusion) %>% table()

# included after full text check
screeing.search2 %>% filter(PMID %in% new.in.new) %>%
  filter(full.text.checked.MS == "yes"| is.na(full.text.checked.MS)) %>% #nrow()# 79 full text checked
  filter(final.inclusion.screening == "Yes") # of that 0 included

# excluded after full text check in s2 (+ reason for exclusion)
screeing.search2 %>% filter(PMID %in% new.in.new) %>%
  filter(full.text.checked.MS == "yes"| is.na(full.text.checked.MS)) %>% 
  filter(final.inclusion.screening == "No") %>% #nrow()   # 79 excluded
  mutate(Reason.for.exclusion = factor(Reason.for.exclusion))%>%
  select(Reason.for.exclusion) %>% table()



# Unique inclusions thesis search + new search ----------------------------
30 + 10 # total 40 inclusions following screening


# Compare to numbers in data extraction file ------------------------------
data %>% distinct(PMID) %>%nrow() # 41 studies


# Difference inclusions vs data extraction: snowballing -------------------
screeing.search1 %>%   filter(inclusie_july2020 == "yes") %>% select(PMID) ->inclusions.S1
screeing.search2 %>%   filter(final.inclusion.screening == "Yes") %>% select(PMID)->inclusions.S2
c(inclusions.S1 , inclusions.S2) %>% unlist() -> inclusions

data %>% filter(!PMID %in% inclusions) # 1 identified via snowballing

# To check: all inclusions from screening files are in dataset
inclusions[(!inclusions %in% data$PMID)] 


# Total inclusions --------------------------------------------------------
# of these 41 studies, 4 studies are included in the systematic review but excluded for the meta-analyses due to missing data. Also see the prepare_data.rmd script.


# save file local ---------------------------------------------------------
# Note these files are also on OSF (https://osf.io/d9eu4/)
write.table(not.in.new, file = "processed_data/not.in.new.search.csv", sep = ';', row.names = F)
write.table(new.in.new, file = "processed_data/new.in.new.search.csv", sep = ';', row.names = F)
write.table(old.in.new, file = "processed_data/old.in.new.search.csv", sep = ';', row.names = F)
