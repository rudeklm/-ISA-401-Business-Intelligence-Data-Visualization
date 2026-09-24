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
  theme   = bs_theme(primary = "#FF5A5F",
                     base_font = font_google("Nunito")),
  sidebar = qc$sidebar(width = 350),
  card(card_header(textOutput("title")),
       DT::DTOutput("table")),
  accordion(open = TRUE,
            accordion_panel("SQL", verbatimTextOutput("sql")),
            accordion_panel("About", "Listings from Inside Airbnb: Chicago (2026-07-20), Columbus (2026-07-23), and Twin Cities (2026-07-21). Built by Lauren Rudek."))
)

server = function(input, output, session) {
  vals = qc$server()
  output$title = renderText(vals$title() %||% "All listings")
  output$table = DT::renderDT(vals$df(),
                              options = list(pageLength = 10))
  output$sql   = renderText(vals$sql() %||%
                              "SELECT * FROM listings")
}

shinyApp(ui, server)