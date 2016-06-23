#Call libraries
library(tm)
library(wordcloud)
library(memoise)

#Read in dataset
death <- read.csv('/home/byronking/Scripts/Death-Row-App/FINAL DATASET.csv')

#Process words
death$Last.Statement <- as.character(death$Last.Statement)

#Remove punctuation, weird UTF codings
death$Last.Statement <- removePunctuation(death$Last.Statement)
death$Last.Statement <- gsub('\xfc\xbe\x8d\x96\x94\xbc\xfc\xbe\x98\x96\x8c\xbc|\xfc\xbe\x8e\x93\xa0\xbc۪','',death$Last.Statement)

#Remove common words
to_remove <- c("and","the","for ","that","this","all","have","not","your","with","would","like","what","but","are","just",
               "dont","did","get","from","its","had","about","because","got","you","was","and","has")
death$Last.Statement <- gsub(paste(to_remove, collapse = '|'),'', death$Last.Statement)

#Use "memoise" to automatically cache the results for wordcloud
getTermMatrix <- memoise(function(race,ed,age) {
  
  #Subset dataframe dynamically on race
  ndeath <- ifelse(race=="White",death[death$Race=='W',],
                   ifelse(race=="Black",death[death$Race=='B',],
                          ifelse(race=="Hispanic",death[death$Race=='H',],
                                 ifelse(race=="Other",death[death$Race=='Other',],
                                        ifelse(race=="All",death,c("ERROR"))))))
  #Process results
  temp1 <- as.numeric(unlist(ndeath))
  ndeath1 <- death[death$Execution %in% temp1, ]
  
  #Subset dataframe dynamically on age and education
  ndeath2 <- subset(ndeath1, ndeath1$Age>=age[1]&ndeath1$Age<=age[2])
  ndeath2$Ed <- as.numeric(ndeath2$Ed)
  findeath <- subset(ndeath2, ndeath2$Ed>=ed[1] & ndeath2$Ed<=ed[2])
  laststatement <- findeath$Last.Statement
  
  #Format word cloud
  laststatement <- iconv(laststatement,to="utf-8-mac")
  docs_laststatement <- Corpus(VectorSource(laststatement))
  tdm_laststatement <- TermDocumentMatrix(docs_laststatement)
  ls_matrix <- as.matrix(tdm_laststatement)
  ls_sort <- sort(rowSums(ls_matrix),decreasing=TRUE)
})

#Use "memoise" to automatically cache the results for the map
getnumex <- memoise(function(race,ed,age) {
  
  #Subset based on age inputs
  ndeath <- ifelse(race=="White",death[death$Race=='W',],
                   ifelse(race=="Black",death[death$Race=='B',],
                          ifelse(race=="Hispanic",death[death$Race=='H',],
                                 ifelse(race=="Other",death[death$Race=='Other',],
                                        ifelse(race=="All",death,c("ERROR"))))))
  
  #Process dataframe
  temp1 <- as.numeric(unlist(ndeath))
  ndeath1 <- death[death$Execution %in% temp1, ]
  
  #Subset on education and age
  ndeath2 <- subset(ndeath1, ndeath1$Age>=age[1]&ndeath1$Age<=age[2])
  ndeath2$Ed <- as.numeric(ndeath2$Ed)
  
  #Process final dataframe
  findeath <- subset(ndeath2, ndeath2$Ed>=ed[1] & ndeath2$Ed<=ed[2])
  laststatement <- findeath$Last.Statement
  noex <- length(laststatement)
  
  #Conditional rendering
  if(noex<1){
  nop <- "There are no executed prisoners who fit the criteria specified below. Maybe try wider criteria?" 
  } else{
  number_of_prisoners <- ifelse(noex==1, paste(noex,"prisoner",sep=" "), paste(noex,"prisoners",sep=" "))
  nop <- paste("Out of the", number_of_prisoners, "with the traits below, we find the words most often used in last statements are:", sep=" ")
  }
})
