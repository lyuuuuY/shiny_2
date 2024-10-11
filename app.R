
packages <- c("shiny", "devtools")
for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

if (!requireNamespace("riksdagenAPI", quietly = TRUE)) {
  devtools::install_github("lyuuuuY/riksdagenAPI")
}

library(shiny)
library(riksdagenAPI)


#ui
ui <- fluidPage(
  titlePanel("TOP 10 Nouns in selected Speeches "),
  sidebarLayout(  #Sidebar layout
    sidebarPanel(
      textInput("start_date","Enter the start of date(yyyy-mm-dd,Optional):" ),
      textInput("end_date","Enter the end of date(yyyy-mm-dd,Optional)"),
      selectInput("type_speech","Enter tpye of speech(Optional):",choices = c("Nej",""),selected = ""),
      selectInput("party","Select the party(Optional):",choices = c("c","l","kd","mp","m","s",
                                                                    "sd","v","-","nyd",""),selected = ""),
      textInput("member","Enter Member ID:"),

      selectInput("size","Select the size of feedback",choices = c(
        "10","50","200","1000","2000","5000","10000")),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      textOutput("speechCountMessage"),
      tableOutput("nounTable")

    )
  )
)

server <- function(input,output,session){


  results <- reactive({
    start_date <- input$start_date
    end_date <- input$end_date
    type_speech <- input$type_speech
    party<- input$party
    member <- input$member
    size <- as.numeric(input$size)
    #Call the riskadagenAPI package function to get the top 10 nouns
    get_top_10_nouns(start_date,end_date,type_speech,party,member,size)
  })

  # Listen for when the user clicks the "Submit" button
  observeEvent(input$submit, {
    result_data <- results() #Retrieve the computed results from the reactive expression

    #Extract the total number of speeches and the top 10 nouns from the results
    speech_count <- result_data$anforande_count
    top_nouns <- result_data$first_10

    #Convert the nouns and their frequencies to a data frame
    noun_data <- data.frame(
      Noun=names(top_nouns),
      Frequency=as.numeric(top_nouns),
      stringsAsFactors = FALSE
    )

    output$speechCountMessage <- renderText({
      paste("The number of speeches：", speech_count)
    })

    output$nounTable <- renderTable({
      noun_data
    })
  })
}
shinyApp(ui = ui, server =server)

