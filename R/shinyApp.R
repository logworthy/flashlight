#' @import shiny
NULL

#' Get the shinyUI object
#'
#' @return shinyUI object
#' @export
#'
getUI <- function() {

  # Define UI for application that draws a histogram
  shinyUI(fluidPage(

    # Application title
    titlePanel("Hello Shiny!"),

    # Sidebar with a slider input for the number of bins
    sidebarLayout(
      sidebarPanel(
        actionButton("refresh", "Refresh"),
        textInput("dir", NULL)
      ),

      # Show a plot of the generated distribution
      mainPanel(
        dataTableOutput("result")
      )
    )
  ))

}

#' get the shinyServer
#'
#' @return shinyServer object
#' @export
#'
getServer <- function() {

  shinyServer(function(input, output) {

    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot
    observeEvent(input$refresh, {
      target_dir <- input$dir
      if(!dir.exists(target_dir)) target_dir <- '.'
      result <- data.frame(name=list.files(target_dir), size=file.size(list.files(target_dir)))
      output$result <- renderDataTable(result, options=list(pageLength=10))
    })

  })

}

#' Get the shinyApp
#'
#' @return a list with components ui and server
#' @export
#'
getApp <- function() {
  list(ui=getUI(), server=getServer())
}

