library(rvest)
library(dplyr)

# read in csvs and delete unnecessary columns

DS2.0 <- read.csv('/Users/Evan/Desktop/focused.csv')
DS2.0 <- DS2.0[-c(1,3,4)]

# extract links and put into list

DS2.0$links <- as.character(DS2.0$links)
LinkList <- DS2.0$links

# create empty vector

output <- character()

# retrieve last statements from all links

for (i in 1:536){
  toc_entry <- read_html(LinkList[i]) %>%
                          html_nodes(xpath='//*[@id="body"]') %>%
                          html_text()
  output <- c(output, toc_entry)

}

# create dataframe

finoutput <- data.frame(output)
finoutput$output <- as.character(finoutput$output)

# process the strings

newfinaloutput <- t(data.frame(strsplit(finoutput$output, "Last Statement:")))
temp<- data.frame(newfinaloutput[,-1])
rownames(temp) <- 1:nrow(temp)
colnames(temp) <- "laststatement"
temp$laststatement <- gsub("\r\n", " ", temp$laststatement)
