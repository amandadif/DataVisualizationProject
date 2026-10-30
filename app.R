library(shiny)
library(ggplot2)

# Part 1 -load cleaned data and add a year column
emails <- read.csv("emails_clean.csv", stringsAsFactors = FALSE)

emails$date_clean <- as.Date(emails$date_clean)
emails$year <- format(emails$date_clean, "%Y")
emails$year[is.na(emails$date_clean)] <- "Unknown"

# Part 2 -assign choices for dropdown menus
mailboxes <- sort(unique(emails$mailbox))
years <- sort(unique(emails$year[emails$year != "Unknown"]))

# Part 3 -ui
ui <- fluidPage(
  titlePanel("Enron Email Dashboard"),
  
  tabsetPanel(
    #First tab-Email Activity
    tabPanel("Email Activity",
             selectInput("activity_mailbox", "Mailbox:", choices = c("All users", mailboxes)),
             plotOutput("year_plot"),
             tableOutput("activity_summary")
    ),
    
    #Second Tab -Search through Emails
    tabPanel("Explore Emails",
             selectInput("explore_mailbox", "Mailbox:", choices = c("All users", mailboxes)),
             selectInput("explore_year", "Year:", choices = c("All years", years, "Unknown")),
             textInput("sender_search", "Search sender:"),
             tableOutput("email_table"),
             textOutput("result_count")
    )
  )
)

# Part 4 -server
server <- function(input, output) {
  
  # emails for the mailbox chosen on tab 1
  activity_data <- reactive({
    data <- emails
    if (input$activity_mailbox != "All users") {
      data <- data[data$mailbox == input$activity_mailbox, ]
    }
    data
  })
  
  #bar plot of emails per year
  output$year_plot <- renderPlot({
    data <- activity_data()
    data <- data[data$year != "Unknown", ]
    
    ggplot(data, aes(x = year)) +
      geom_bar() +
      labs(title = "Emails by Year", x = "Year", y = "Number of Emails")
  })
  
  #small summary table under the plot
  output$activity_summary <- renderTable({
    data <- activity_data()
    
    data.frame(
      Metric = c("Number of emails", "Mailboxes represented", "Emails with missing dates"),
      Value = c(nrow(data), length(unique(data$mailbox)), sum(is.na(data$date_clean)))
    )
  })
  
  #emails that match the three filters on second tab
  filtered_emails <- reactive({
    data <- emails
    
    if (input$explore_mailbox != "All users") {
      data <- data[data$mailbox == input$explore_mailbox, ]
    }
    
    if (input$explore_year != "All years") {
      data <- data[data$year == input$explore_year, ]
    }
    
    if (input$sender_search != "") {
      data <- data[grepl(input$sender_search, data$sender_name, ignore.case = TRUE), ]
    }
    
    data
  })
  
  #table of matching emails and the match count
  output$email_table <- renderTable({
    data <- filtered_emails()
    head(data[, c("mailbox", "folder", "sender_name", "subject", "date_clean")], 50)
  })
  
  output$result_count <- renderText({
    paste("Matching emails:", nrow(filtered_emails()), "(showing first 50)")
  })
}

#run the app
shinyApp(ui = ui, server = server)
