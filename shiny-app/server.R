#Call libraries
library(shiny)
library(ggvis)
library(rgdal)
library(rgeos)
library(magrittr)
library(dplyr)
library(RColorBrewer)
library(data.table)
library(maptools)
library(gpclib)

#Render app
shinyServer(function(input, output) {
  
  #Show progress bar while loading everything ------------------------------
  progress <- shiny::Progress$new()
  progress$set(message="Loading maps/data", value=0)
  
  #Render word cloud and plot dynamically
  output$plot1 <- reactivePlot(function() {
    
    ls_sort <- getTermMatrix(input$Race,input$INED,input$INAGE)
    
    wordcloud(words = names(ls_sort), freq = ls_sort, min.freq = 1,
                  max.words=100, random.order=FALSE, rot.per=0.35, 
                  colors=brewer.pal(9, "PuBuGn"))
    
  })
  
  #Render text dynamically
  output$numberexecuted <- renderText({
    getnumex(input$Race,input$INED,input$INAGE)
  })
  
  #Read in GeoJSON file
    texas <-readOGR("/home/byronking/Scripts/Death-Row-App/counties_2010.geojson", "OGRGeoJSON")
    gpclibPermit()==TRUE
    
  #Plot geographic outline and county shapes
    map <- ggplot2::fortify(texas, region='NAME10')
    
  #Manipulate dataframe
    death$Ed <- as.numeric(as.character(death$Ed))
    
  ##Retrieve county stats
    #Create binary variables for race
    ndeath2 <- death
    ndeath2$White_Executions <- ifelse(ndeath2$Race=="W", 1, 0)
    ndeath2$Black_Executions <- ifelse(ndeath2$Race=="B", 1, 0)
    ndeath2$Hispanic_Executions <- ifelse(ndeath2$Race=="H", 1, 0)
    ndeath2$Other_Executions <- ifelse(ndeath2$Race=="Other", 1, 0)
  
    #Summarize data by county
    by_county <- group_by(ndeath2,County)
    death_temp <- summarise(by_county,
                            Number_Executions = n(),
                            Average_Age = round(mean(Age, na.rm = TRUE),0),
                            Average_Education = round(mean(Ed, na.rm = TRUE),0),
                            White_Executions = sum(White_Executions),
                            Black_Executions = sum(Black_Executions),
                            Hispanic_Executions = sum(Hispanic_Executions),
                            Other_Executions = sum(Other_Executions))
    death_temp$County <- as.character(death_temp$County)
    
    #Create dataframe with counties
    countylist <- as.data.frame(t(as.data.frame(as.list(levels(as.factor(map$id))))))
    rownames(countylist) <- NULL
    names(countylist) <- "County"
    
    #Join dataframes
    final <- right_join(death_temp, countylist, by = "County")
    final$Number_Executions[is.na(final$Number_Executions)] <- 0
    final$White_Executions[is.na(final$White_Executions)] <- 0
    final$Black_Executions[is.na(final$Black_Executions)] <- 0
    final$Hispanic_Executions[is.na(final$Hispanic_Executions)] <- 0
    final$Other_Executions[is.na(final$Other_Executions)] <- 0
    
    #Pipe final dataframe to map on county
    map %<>% mutate(id=gsub(" County, TX", "", id)) %>%
      left_join(final, by=c("id"="County"))
    
    #Create tooltip function
    death_values <- function(x) {
      if(is.null(x)) return(NULL)
      row <- final %>% filter(County==x$id) 
      paste0(names(row), ": ", format(row), collapse = "<br />")
    }
    
    #Create map
    map %>%
      group_by(group, id) %>%
      ggvis(~long, ~lat) %>%
      layer_paths(fill=input_select(label="Race:",
                                     choices=final %>%
                                       select(ends_with("_Executions")) %>%
                                       colnames,
                                      id="Crime",                                  
                                      map=as.name),
                  strokeWidth := 0.5, stroke := "grey") %>%
      scale_numeric("fill", range=c("#f0f0f0", "#e9af23")) %>%
      add_tooltip(death_values, "hover") %>%
      add_legend("fill", title="Number of Executions") %>%
      hide_axis("x") %>% hide_axis("y") %>%
      set_options(width="auto", height=600, keep_aspect=TRUE) %>%
      bind_shiny("death_plot_1", "death_plot_1_ui")
    
    
    # Turn off progress bar ---------------------------------------------------
    
    progress$close()

})
