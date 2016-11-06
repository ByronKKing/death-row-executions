library(RCurl)

# Import and scrape web table data from url, create dataframe deathset

url <- "http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html"
deathset <- url %>%
  html() %>%
  html_nodes(xpath='//*[@id="body"]/table') %>%
  html_table()
deathset <- deathset[[1]]
deathset <- data.frame(deathset)

# extract all html links and create dataframe

AllHtml <- getHTMLLinks('http://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html')
DF <- data.frame(AllHtml)

# write all of these as csvs

write.csv(deathset, file="Deathset.csv")
write.csv(DF, file="Deathsetlinks.csv")


