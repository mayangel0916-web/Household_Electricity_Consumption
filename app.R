
library(shiny)
library(ggplot2)

# Load household electricity dataset
household_data <- read.csv("household_electricity.csv")

# Check required columns
required_columns <- c(
  "Household_ID",
  "Household_Size",
  "Monthly_Income_PHP",
  "Number_of_Appliances",
  "Air_Conditioner_Usage_Hours",
  "Refrigerator_Usage_Hours",
  "Television_Usage_Hours",
  "Lighting_Usage_Hours",
  "Monthly_Electricity_Consumption_kWh",
  "Electricity_Rate_PHP",
  "Monthly_Electricity_Bill_PHP",
  "Energy_Saving_Practice"
)

if (!all(required_columns %in% names(household_data))) {
  stop("Dataset columns do not match the required columns.")
}

# Feminine color palette
pink <- "#D78EAD"
rose <- "#C16C91"
mauve <- "#A65F82"
plum <- "#75445F"
gold <- "#C58B75"
cream <- "#FFF9FB"
light_pink <- "#F8E8EF"
soft_pink <- "#F2D5E1"

# Dashboard UI
ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #FFF9FB;
        font-family: 'Segoe UI', sans-serif;
        color: #75445F;
      }

      .main-header {
        background: linear-gradient(120deg, #F2D5E1, #F8E8EF);
        padding: 28px;
        border-radius: 18px;
        margin-bottom: 25px;
        border: 1px solid #E8C2D2;
        box-shadow: 0 4px 12px rgba(117,68,95,0.08);
      }

      .main-header h1 {
        color: #75445F;
        font-weight: 800;
        margin-top: 0;
      }

      .main-header p {
        color: #93677C;
        font-size: 15px;
        margin-bottom: 0;
      }

      .sidebar-panel {
        background-color: #F8E8EF;
        padding: 20px;
        border-radius: 16px;
        border: 1px solid #E8C2D2;
      }

      .sidebar-panel h4 {
        color: #75445F;
        font-weight: bold;
      }

      .summary-card {
        background-color: white;
        padding: 20px;
        border-radius: 16px;
        border: 1px solid #E8C2D2;
        border-left: 6px solid #D78EAD;
        box-shadow: 0 4px 12px rgba(117,68,95,0.07);
        min-height: 120px;
        margin-bottom: 18px;
      }

      .summary-card h4 {
        color: #A65F82;
        font-size: 14px;
        font-weight: bold;
      }

      .summary-card h2 {
        color: #75445F;
        font-weight: 800;
        margin-top: 8px;
      }

      .panel-box {
        background-color: white;
        padding: 18px;
        border-radius: 16px;
        border: 1px solid #E8C2D2;
        box-shadow: 0 4px 12px rgba(117,68,95,0.06);
        margin-bottom: 22px;
      }

      .panel-box h4 {
        color: #A65F82;
        font-weight: bold;
        margin-top: 0;
      }

      .btn-reset {
        background-color: #A65F82;
        color: white;
        border: none;
        border-radius: 9px;
        padding: 10px 18px;
        font-weight: bold;
        width: 100%;
      }

      .btn-reset:hover {
        background-color: #75445F;
        color: white;
      }

      .form-control {
        border-radius: 8px;
        border: 1px solid #DDB5C7;
      }

      .control-label {
        color: #75445F;
        font-weight: 600;
      }

      .footer {
        background-color: #F8E8EF;
        color: #93677C;
        padding: 16px;
        text-align: center;
        border-radius: 12px;
        margin-top: 20px;
      }

      .dataTables_wrapper {
        color: #75445F;
      }
    "))
  ),
  
  # Header
  div(
    class = "main-header",
    h1("♡ Household Electricity Insights"),
    p("Household Electricity Consumption and Monthly Expenses"),
    p("Understanding electricity usage, monthly bills, and energy-saving practices.")
  ),
  
  sidebarLayout(
    
    # Sidebar filters
    sidebarPanel(
      width = 3,
      
      div(
        class = "sidebar-panel",
        
        h4("♡ Dashboard Filters"),
        
        selectInput(
          "household_size",
          "Household Size:",
          choices = c("All", sort(unique(household_data$Household_Size))),
          selected = "All"
        ),
        
        selectInput(
          "energy_practice",
          "Energy-Saving Practice:",
          choices = c(
            "All",
            sort(unique(as.character(household_data$Energy_Saving_Practice)))
          ),
          selected = "All"
        ),
        
        selectInput(
          "appliances",
          "Number of Appliances:",
          choices = c(
            "All",
            sort(unique(household_data$Number_of_Appliances))
          ),
          selected = "All"
        ),
        
        actionButton(
          "reset",
          "♡ Reset Filters",
          class = "btn-reset"
        ),
        
        tags$hr(),
        
        h4("About This Project"),
        
        p("This dashboard explores household electricity consumption and monthly expenses."),
        
        p("Use the filters to compare households and understand their electricity usage.")
      )
    ),
    
    # Main dashboard area
    mainPanel(
      width = 9,
      
      # Summary cards
      fluidRow(
        
        column(
          4,
          div(
            class = "summary-card",
            h4("♡ TOTAL HOUSEHOLDS"),
            h2(textOutput("total_households"))
          )
        ),
        
        column(
          4,
          div(
            class = "summary-card",
            h4("⚡ AVERAGE CONSUMPTION"),
            h2(textOutput("average_consumption"))
          )
        ),
        
        column(
          4,
          div(
            class = "summary-card",
            h4("₱ AVERAGE MONTHLY BILL"),
            h2(textOutput("average_bill"))
          )
        )
      ),
      
      # First graph
      div(
        class = "panel-box",
        h4("♡ Electricity Consumption by Household Size"),
        plotOutput("consumption_plot", height = "300px")
      ),
      
      # Second graph
      div(
        class = "panel-box",
        h4("♡ Monthly Electricity Expenses"),
        plotOutput("expenses_plot", height = "300px")
      ),
      
      # Third graph
      div(
        class = "panel-box",
        h4("♡ Household Energy-Saving Practices"),
        plotOutput("energy_plot", height = "300px")
      ),
      
      # Household data table
      div(
        class = "panel-box",
        h4("♡ Household Electricity Data"),
        tableOutput("household_table")
      )
    )
  ),
  
  # Footer
  div(
    class = "footer",
    "♡ Household Electricity Consumption and Monthly Expenses | Quantitative Methods Project ♡"
  )
)

# Server
server <- function(input, output, session) {
  
  # Filter household records
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
  
  # Reset filters
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
  
  # Summary cards
  output$total_households <- renderText({
    nrow(filtered_data())
  })
  
  output$average_consumption <- renderText({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return("No data")
    }
    
    paste(
      round(
        mean(data$Monthly_Electricity_Consumption_kWh,
             na.rm = TRUE),
        2
      ),
      "kWh"
    )
  })
  
  output$average_bill <- renderText({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return("No data")
    }
    
    paste0(
      "₱",
      format(
        round(
          mean(data$Monthly_Electricity_Bill_PHP,
               na.rm = TRUE),
          2
        ),
        big.mark = ",",
        nsmall = 2
      )
    )
  })
  
  # Graph 1: Consumption by household size
  output$consumption_plot <- renderPlot({
    
    data <- filtered_data()
    
    validate(
      need(nrow(data) > 0, "No data available for these filters.")
    )
    
    ggplot(
      data,
      aes(
        x = factor(Household_Size),
        y = Monthly_Electricity_Consumption_kWh
      )
    ) +
      geom_boxplot(
        fill = pink,
        color = plum,
        alpha = 0.85,
        outlier.color = gold
      ) +
      labs(
        x = "Household Size",
        y = "Electricity Consumption (kWh)"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.background = element_rect(fill = cream, color = NA),
        panel.background = element_rect(fill = cream, color = NA),
        plot.title = element_text(color = plum, face = "bold"),
        axis.title = element_text(color = plum),
        axis.text = element_text(color = "#93677C")
      )
  })
  
  # Graph 2: Monthly electricity expenses
  output$expenses_plot <- renderPlot({
    
    data <- filtered_data()
    
    validate(
      need(nrow(data) > 0, "No data available for these filters.")
    )
    
    ggplot(
      data,
      aes(x = Monthly_Electricity_Bill_PHP)
    ) +
      geom_histogram(
        bins = 10,
        fill = rose,
        color = "white",
        alpha = 0.9
      ) +
      labs(
        x = "Monthly Electricity Bill (PHP)",
        y = "Number of Households"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.background = element_rect(fill = cream, color = NA),
        panel.background = element_rect(fill = cream, color = NA),
        axis.title = element_text(color = plum),
        axis.text = element_text(color = "#93677C")
      )
  })
  
  # Graph 3: Energy-saving practices
  output$energy_plot <- renderPlot({
    
    data <- filtered_data()
    
    validate(
      need(nrow(data) > 0, "No data available for these filters.")
    )
    
    ggplot(
      data,
      aes(x = factor(Energy_Saving_Practice), fill = factor(Energy_Saving_Practice))
    ) +
      geom_bar(color = "white", alpha = 0.9) +
      scale_fill_manual(
        values = c(
          "Yes" = "#D78EAD",
          "No" = "#8979B9"
        )
      ) +
      labs(
        x = "Energy-Saving Practice",
        y = "Number of Households",
        fill = "Practice"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.background = element_rect(fill = cream, color = NA),
        panel.background = element_rect(fill = cream, color = NA),
        axis.title = element_text(color = plum),
        axis.text = element_text(color = "#93677C"),
        legend.position = "bottom"
      )
  })
  
  # Household data table
  output$household_table <- renderTable({
    
    filtered_data()
    
  }, striped = TRUE, bordered = TRUE, hover = TRUE)
  
}

# Run Shiny application
shinyApp(ui = ui, server = server)
