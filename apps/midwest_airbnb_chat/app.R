# ISA 401 Midwest Airbnb Chat: ask questions, get SQL, a table, or a chart back
library(querychat)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat::querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)

qc$app_obj()

library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "Midwest Airbnb Explorer",
  window_title = "Midwest Airbnb Explorer",
  theme = bs_theme(
    bootswatch = "flatly",
    primary = "#FF5A5F",
    base_font = font_google("Inter")
  ),
  sidebar = qc$sidebar(),
  navset_card_tab(
    nav_panel(
      "About",
      h4("About this app"),
      p("Ask questions in plain English about 14,887 Airbnb listings in Chicago,",
        "Columbus, and the Twin Cities. The assistant writes SQL, runs it,",
        "and shows you the query and the results."),
      p("Data: Inside Airbnb. Built with R, querychat, and ellmer.")
    ),
    nav_panel(
      "Results",
      card(card_header("SQL query"), verbatimTextOutput("sql")),
      card(card_header("Data"), DT::DTOutput("table"))
    )
  )
)

server <- function(input, output, session) {
  qc_vals <- qc$server()
  output$sql <- renderText({
    q <- qc_vals$sql()
    if (is.null(q) || q == "") "SELECT * FROM listings" else q
  })
  output$table <- DT::renderDT(qc_vals$df())
}

shinyApp(ui, server)
