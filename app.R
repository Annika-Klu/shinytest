# set path so packages are loaded from local dir
local_dir <- "R_packages"
.libPaths(c(local_dir, .libPaths()))

library(shiny)
library(httr2)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  titlePanel("Hello"),
  textInput("email", "Your Email", ""),
  actionButton("submit", "Submit")
)

submit_email <- function(email) {
    req <- request("http://localhost:4444/file")
    headers <- req %>%
        req_headers(
            "MY-COOL-TOKEN" = "04940304"
        )

    req_body <- headers %>%
        req_body_json(
            list(email = email)
        )

    return (req_body %>%
        req_perform())
}


server <- function(input, output, session) {
    observeEvent(input$submit, {
    email <- input$email
    response <- submit_email(email) %>%
        resp_body_json()
    status <- submit_email(email) %>%
        resp_status()
    # Extract response content
    if (status != 200) {
      # Handle error
      showModal(modalDialog(
        title = "Error",
        "Failed to fetch data. Please try again later.",
        footer = NULL
      ))
    } else {
      # Show modal with response content
      showModal(modalDialog(
        title = "Response",
        width= "100%",
        response,
        footer = tagList(
          modalButton("OK")
        )
      ))
    }
  })
}

shinyApp(ui, server)