library(shiny)

ui <- fluidPage(
  titlePanel("Hello"),
  textInput("email", "Your Email", ""),
  actionButton("submit", "Submit")
)

server <- function(input, output, session) {
  observeEvent(input$submit, {
    email <- input$email
    # You can make a POST request to your backend here
    # Example: 
    # response <- httr::POST("https://mybackendaddress.com", body = list(email = email))
    # print(response)
  })
}

shinyApp(ui, server)