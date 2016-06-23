#Call shiny
library(shiny)

#Create UI
shinyUI(fluidPage(
  #App title
  titlePanel("Execution Data Visualizations"),
  sidebarLayout(
    sidebarPanel(
      p(strong("Texas Death Row Analysis")),
      hr(),
      p("In this app, we look to better understand executed death row prisoners through a racial lens from multiple perspectives.  In order to do this, we created two interactive visualizations in a shiny app, first focusing on the content of prisoner's last statement and second focusing on where the majority of executions occur."),
      hr(),
      p("The word cloud visualization is reactive to the parameters below the cloud within the tab, with the sample size from which the word cloud takes listed above. We focused on race, age, and education level to best fit the scope our hypothesis."),
      hr(),
      p("The map visualization is reactive to race, and allows an in depth look by county which can be achieved by hovering each given county. Due to the size of the dataset and the nature of mapping so many variables on counties, reactive changes to this map are not instantaneous, and  may take some time to load."),
      hr(),
      p("Written by ", a(href="https://twitter.com/EvanRomanko", "Evan Romanko"), " and ", a(href="https://github.com/ByronKKing", "Byron King")),
      hr(),
      p("Dataset used available ",a(href="https://drive.google.com/open?id=0B5rBiZTYG3OjQUI3T1NiX3BCMk0", "here.")),
      width=3
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Last Statement Word Cloud",
               wellPanel(p(strong(textOutput("numberexecuted")))), 
               conditionalPanel(condition = "output.numberexecuted != 'There are no executed prisoners who fit the criteria specified below. Maybe try wider criteria?'", plotOutput('plot1')),
               wellPanel(
                 selectInput("Race", "Choose a Race:", choices = c("All","White","Black","Hispanic","Other")),
                 sliderInput("INAGE", "Age of Executed:", min = 24, max = 67, value = c(30,50), step = 1),
                 sliderInput("INED", "Level of Education:", min = 0, max = 16, value = c(9,12), step = 1))),
      tabPanel("Executions by County and Race Map", uiOutput("death_plot_1_ui"), ggvisOutput("death_plot_1"))
    )
  )
)
)
)