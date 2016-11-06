## Death Row Executions: Last Statements

This is a personal interest project that my friend Evan Romanko and I worked on. We analyzed the the last statements of executed inmates in Texas prisons, and collected their demographic information. 

One can find the information for each executed offender who died on death row in Texas, including their last statements, here:
https://www.tdcj.state.tx.us/death_row/dr_executed_offenders.html

In this repo, you can find the webscraping R and Python scripts we used to collect the demographic and last statement information for each offender. You will also find the final dataset we used to build a Shiny app. There were 537 Texas inmates who died on death row at the time when we scraped this data.

The Shiny app creates a word cloud of the most frequent words the inmates used in their last statements. It also creates a map of Texas, broken down by county, and includes the aggregated demographic information of these inmates by the county in which they committed their crime.
