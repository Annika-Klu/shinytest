# set path so packages are loaded from local dir
local_dir <- "R_packages"
.libPaths(c(local_dir, .libPaths()))

library(shiny)
library(shinyjs)
library(httr2)

source("methods.R")

choices <- c("Strongly Disagree", "Disagree", "Agree", "Strongly Agree")
likertInput <- function(inputId, label) {
  tagList(
    tags$label(label, `for` = inputId),
    radioButtons(inputId, label = NULL, selected = "", choices = choices)
  )
}

ui <- fluidPage(
  shinyjs::useShinyjs(),
  shinyjs::extendShinyjs(script = "custom.js", functions = c("test")),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  titlePanel("Fill this in you moron"),
  fluidRow(
    column(width = 12,
           wellPanel(
             h4("Please rate your agreement with the following statements:"),
             # Use lapply to generate likertInput for 19 questions
             lapply(1:19, function(i) {
               likertInput(paste0("likert", i), paste0("Question ", i, ": "))
             })
           )
    )
  ),
  actionButton("submit", "Submit")
)

check_completion <- function(input) {
    unfilled_inputs <- character(0)
    for (i in 1:19) {
      input_id <- paste0("likert", i)
      if (is.null(input[[input_id]])) {
        unfilled_inputs <- c(unfilled_inputs, input_id)
      }
    }
     if (length(unfilled_inputs) > 0) {
      # Scroll to the first unfilled input
      shinyjs::runjs("document.body.scrollTop = 0;")
      shinyjs::toggleState("submit", "enable") # Enable submit button
      return(FALSE)
    } else {
      # All inputs filled, proceed
      # You can put your code for data processing or further actions here
      # For demonstration, just print a message
      print("All questions answered")
    }
}

server <- function(input, output, session) {
  js$test()

  observeEvent(input$submit, {
    email <- input$email
    check_completion(input)
    # response <- submit_data()
    # # Extract response content
    # if (response$status != 201) {
    #   # Handle error
    #   showModal(modalDialog(
    #     title = "Error",
    #     "Failed to fetch data. Please try again later.",
    #     footer = NULL
    #   ))
    # } else {
    #   # Show modal with response content
    #   showModal(modalDialog(
    #     title = "Response",
    #     width= "100%",
    #     response,
    #     footer = tagList(
    #       modalButton("OK")
    #     )
    #   ))
    # }
  })
}

shinyApp(ui, server)