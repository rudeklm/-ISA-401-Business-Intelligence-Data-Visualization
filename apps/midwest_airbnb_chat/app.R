# Midwest Airbnb Explorer: ask questions, get SQL, a table, or a chart back
library(shiny)
library(bslib)
library(querychat)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
)

ui = page_sidebar(
  title   = "Midwest Airbnb Explorer",
  theme   = bs_theme(preset = "minty", primary = "#FF5A5F"),
  sidebar = sidebar(qc$ui(), width = 420),
  navset_card_tab(
    nav_panel(
      "Explorer",
      h5("SQL behind the table"),
      verbatimTextOutput("sql"),
      DT::DTOutput("table")
    ),
    nav_panel(
      "About",
      p("The listings come from Inside Airbnb: Chicago (2026-07-20), Columbus (2026-07-23),
        and the Twin Cities (2026-07-21)."),
      p("Built by Lauren Rudek for ISA 401, Miami University, Fall 2026.")
    )
  )
)

server = function(input, output, session) {
  vals = qc$server()
  output$sql   = renderText(vals$sql() %||% "SELECT * FROM listings")
  output$table = DT::renderDT(vals$df(), options = list(scrollX = TRUE))
}

shinyApp(ui, server)