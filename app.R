
library(shiny)
library(ggplot2)

# ==========================================
# 1. LOAD DATASET
# ==========================================

household_data <- read.csv("household_electricity.csv")

# Feminine-inspired color palette
pink <- "#D78EAD"
mauve <- "#A65F82"
lavender <- "#8979B9"
rose_gold <- "#C58B75"
plum <- "#75445F"
cream <- "#FFF9FB"

# ==========================================
# 2. USER INTERFACE
# ==========================================

ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #FFF9FB;
        font-family: 'Segoe UI', sans-serif;
        color: #75445F;
      }

      .main-header {
        background: linear-gradient(120deg, #D78EAD, #8979B9);
        color: white;
        padding: 25px;
        border-radius: 16px;
        margin-bottom: 22px;
        box-shadow: 0 4px 12px rgba(117,68,95,0.15);
      }

      .main-header h2 {
        font-weight: 700;
        margin-top: 5px;
      }

      .sidebar {
        background-color: #F8E8EF;
        border-radius: 15px;
        padding: 18px;
      }

      .well {
        background-color: #F8E8EF;
        border: none;
        border-radius: 15px;
      }

      .filter-title {
        color: #75445F;
        font-weight: bold;
        margin-bottom: 15px;
      }

      .stat-card {
        background: white;
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 18px;
        text-align: center;
        min-height: 115px;
        box-shadow: 0 3px 12px rgba(117,68,95,0.10);
        border-top: 5px solid #D78EAD;
      }

      .stat-card h4 {
        color: #A65F82;
        font-size: 14px;
        font-weight: 600;
      }

      .stat-card h2 {
        color: #75445F;
        font-size: 27px;
        font-weight: bold;
        margin-top: 8px;
      }

      .section-card {
        background: white;
        padding: 18px;
        border-radius: 15px;
        margin-bottom: 20px;
        box-shadow: 0 3px 12px rgba(117,68,95,0.08);
        width: 100%;
        box-sizing: border-box;
        overflow: hidden;
      }

      .section-card h4 {
        color: #75445F;
        font-weight: bold;
      }

      .table-responsive {
        width: 100%;
        max-width: 100%;
        overflow-x: auto;
        overflow-y: hidden;
        display: block;
        box-sizing: border-box;
        border-radius: 8px;
      }

      .table-responsive table {
        min-width: 1400px;
        width: 100%;
        white-space: nowrap;
        margin-bottom: 0;
      }

      .table-responsive th {
        background-color: #F8E8EF;
        color: #75445F;
        font-weight: bold;
      }

      .table-responsive td,
      .table-responsive th {
        padding: 9px 12px;
        white-space: nowrap;
      }

      .btn {
        background-color: #A65F82;
        color: white;
        border: none;
        border-radius: 9px;
        font-weight: bold;
      }

      .btn:hover {
        background-color: #75445F;
        color: white;
      }

      .control-label {
        color: #75445F;
        font-weight: 600;
      }

      .footer-text {
        text-align: center;
        color: #A65F82;
        padding: 15px;
        font-size: 12px;
      }
    "))
  ),
  
  # Dashboard Header
  div(
    class = "main-header",
    h2("Household Electricity Consumption"),
    h4("and Monthly Expenses"),
    p("An Interactive Dashboard for Exploring Household Energy Usage and Electricity Costs")
  ),
  
  sidebarLayout(
    
    # Sidebar Filters
    sidebarPanel(
      class = "sidebar",
      
      h4(class = "filter-title", "♡ Dashboard Filters"),
      
      selectInput(
        "household_size",
        "Household Size:",
        choices = c(
          "All",
          sort(unique(household_data$Household_Size))
        )
      ),
      
      selectInput(
        "energy_practice",
        "Energy-Saving Practice:",
        choices = c(
          "All",
          sort(unique(as.character(
            household_data$Energy_Saving_Practice
          )))
        )
      ),
      
      selectInput(
        "appliances",
        "Number of Appliances:",
        choices = c(
          "All",
          sort(unique(household_data$Number_of_Appliances))
        )
      ),
      
      br(),
      
      actionButton(
        "reset",
        "Reset All Filters",
        icon = icon("refresh")
      ),
      
      br(), br(),
      
      p("Select the filters to explore household electricity consumption and expenses.")
    ),
    
    # Main Dashboard
    mainPanel(
      
      # Summary Cards
      fluidRow(
        
        column(
          4,
          div(
            class = "stat-card",
            h4("TOTAL HOUSEHOLDS"),
            h2(textOutput("total_households"))
          )
        ),
        
        column(
          4,
          div(
            class = "stat-card",
            h4("AVERAGE CONSUMPTION"),
            h2(textOutput("average_consumption"))
          )
        ),
        
        column(
          4,
          div(
            class = "stat-card",
            h4("AVERAGE MONTHLY BILL"),
            h2(textOutput("average_bill"))
          )
        )
      ),
      
      # Graph 1
      div(
        class = "section-card",
        h4("♡ 1. Electricity Consumption by Household Size"),
        plotOutput("consumption_plot", height = "320px")
      ),
      
      # Graph 2
      div(
        class = "section-card",
        h4("♡ 2. Monthly Electricity Bill Distribution"),
        plotOutput("bill_plot", height = "320px")
      ),
      
      # Graph 3
      div(
        class = "section-card",
        h4("♡ 3. Household Energy-Saving Practices"),
        plotOutput("practice_plot", height = "320px")
      ),
      
      # Data Table
      div(
        class = "section-card",
        h4("♡ Household Electricity Data"),
        p("Scroll horizontally inside the table to view all columns."),
        
        div(
          class = "table-responsive",
          tableOutput("household_table")
        )
      ),
      
      # Footer
      div(
        class = "footer-text",
        "Household Electricity Consumption and Monthly Expenses | Quantitative Methods Project"
      )
    )
  )
)

# ==========================================
# 3. SERVER
# ==========================================

server <- function(input, output, session) {
  
  # Filtered Dataset
  filtered_data <- reactive({
    
    data <- household_data
    
    if (input$household_size != "All") {
      data <- data[
        data$Household_Size == as.numeric(input$household_size),
      ]
    }
    
    if (input$energy_practice != "All") {
      data <- data[
        as.character(data$Energy_Saving_Practice) ==
          input$energy_practice,
      ]
    }
    
    if (input$appliances != "All") {
      data <- data[
        data$Number_of_Appliances == as.numeric(input$appliances),
      ]
    }
    
    data
  })
  
  # Reset Filters
  observeEvent(input$reset, {
    
    updateSelectInput(
      session,
      "household_size",
      selected = "All"
    )
    
    updateSelectInput(
      session,
      "energy_practice",
      selected = "All"
    )
    
    updateSelectInput(
      session,
      "appliances",
      selected = "All"
    )
  })
  
  # ==========================================
  # 4. SUMMARY CARDS
  # ==========================================
  
  output$total_households <- renderText({
    
    nrow(filtered_data())
    
  })
  
  output$average_consumption <- renderText({
    
    data <- filtered_data()
    
    if (nrow(data) == 0) return("N/A")
    
    paste0(
      round(
        mean(data$Monthly_Electricity_Consumption_kWh, na.rm = TRUE),
        1
      ),
      " kWh"
    )
  })
  
  output$average_bill <- renderText({
    
    data <- filtered_data()
    
    if (nrow(data) == 0) return("N/A")
    
    paste0(
      "₱",
      format(
        round(
          mean(data$Monthly_Electricity_Bill_PHP, na.rm = TRUE),
          2
        ),
        big.mark = ",",
        nsmall = 2
      )
    )
  })
  
  # ==========================================
  # 5. GRAPH 1
  # Electricity Consumption by Household Size
  # ==========================================
  
  output$consumption_plot <- renderPlot({
    
    data <- filtered_data()
    
    validate(
      need(nrow(data) > 0,
           "No household records match these filters.")
    )
    
    household_levels <- sort(unique(data$Household_Size))
    
    graph_colors <- setNames(
      colorRampPalette(c(
        pink,
        lavender,
        rose_gold,
        mauve,
        "#B99ACB",
        "#E8AFC5",
        "#A78BC2"
      ))(length(household_levels)),
      as.character(household_levels)
    )
    
    ggplot(
      data,
      aes(
        x = factor(Household_Size, levels = household_levels),
        y = Monthly_Electricity_Consumption_kWh,
        fill = factor(Household_Size)
      )
    ) +
      
      geom_boxplot(
        alpha = 0.85,
        width = 0.65,
        na.rm = TRUE
      ) +
      
      scale_fill_manual(
        values = graph_colors,
        drop = FALSE
      ) +
      
      labs(
        title = "Electricity Consumption by Household Size",
        x = "Household Size",
        y = "Monthly Electricity Consumption (kWh)"
      ) +
      
      theme_minimal(base_size = 13) +
      
      theme(
        legend.position = "none",
        plot.title = element_text(
          color = plum,
          face = "bold",
          size = 14
        ),
        plot.background = element_rect(
          fill = "white",
          color = NA
        ),
        axis.text = element_text(color = plum)
      )
  })
  
  # ==========================================
  # 6. GRAPH 2
  # Monthly Electricity Bill Distribution
  # ==========================================
  
  output$bill_plot <- renderPlot({
    
    data <- filtered_data()
    
    validate(
      need(nrow(data) > 0,
           "No household records match these filters.")
    )
    
    ggplot(
      data,
      aes(x = Monthly_Electricity_Bill_PHP)
    ) +
      
      geom_histogram(
        bins = 12,
        fill = pink,
        color = "white",
        alpha = 0.9,
        na.rm = TRUE
      ) +
      
      labs(
        title = "Monthly Electricity Bill Distribution",
        x = "Monthly Electricity Bill (PHP)",
        y = "Number of Households"
      ) +
      
      theme_minimal(base_size = 13) +
      
      theme(
        plot.title = element_text(
          color = plum,
          face = "bold",
          size = 14
        ),
        plot.background = element_rect(
          fill = "white",
          color = NA
        ),
        axis.text = element_text(color = plum)
      )
  })
  
  # ==========================================
  # 7. GRAPH 3
  # Household Energy-Saving Practices
  # ==========================================
  
  output$practice_plot <- renderPlot({
    
    data <- filtered_data()
    
    validate(
      need(nrow(data) > 0,
           "No household records match these filters.")
    )
    
    practice_data <- as.data.frame(
      table(data$Energy_Saving_Practice)
    )
    
    names(practice_data) <- c(
      "Practice",
      "Households"
    )
    
    practice_data <- practice_data[
      practice_data$Households > 0,
    ]
    
    validate(
      need(nrow(practice_data) > 0,
           "No energy-saving practice data available.")
    )
    
    practice_colors <- setNames(
      colorRampPalette(c(
        lavender,
        pink,
        rose_gold,
        mauve
      ))(nrow(practice_data)),
      as.character(practice_data$Practice)
    )
    
    ggplot(
      practice_data,
      aes(
        x = Practice,
        y = Households,
        fill = Practice
      )
    ) +
      
      geom_col(
        width = 0.6,
        alpha = 0.9
      ) +
      
      scale_fill_manual(
        values = practice_colors
      ) +
      
      labs(
        title = "Household Energy-Saving Practices",
        x = "Energy-Saving Practice",
        y = "Number of Households"
      ) +
      
      theme_minimal(base_size = 13) +
      
      theme(
        legend.position = "none",
        plot.title = element_text(
          color = plum,
          face = "bold",
          size = 14
        ),
        plot.background = element_rect(
          fill = "white",
          color = NA
        ),
        axis.text = element_text(color = plum)
      )
  })
  
  # ==========================================
  # 8. HOUSEHOLD DATA TABLE
  # ==========================================
  
  output$household_table <- renderTable({
    
    data <- filtered_data()
    
    validate(
      need(nrow(data) > 0,
           "No household records match these filters.")
    )
    
    data
    
  },
  striped = TRUE,
  bordered = TRUE,
  hover = TRUE,
  spacing = "s",
  width = "100%"
  )
}

# ==========================================
# 9. RUN SHINY DASHBOARD
# ==========================================

shinyApp(ui = ui, server = server)
