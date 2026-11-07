
# ==========================================
# HOUSEHOLD ELECTRICITY CONSUMPTION
# AND MONTHLY EXPENSES
# QUANTITATIVE METHODS PROJECT
# ==========================================

# 1. Load required library
library(ggplot2)

# 2. Load dataset
household_data <- read.csv("household_electricity.csv")

# 3. Display dataset information
cat("HOUSEHOLD ELECTRICITY ANALYSIS\n")
cat("================================\n")

cat("\nDataset Dimensions:\n")
print(dim(household_data))

cat("\nDataset Structure:\n")
str(household_data)

# ==========================================
# 4. DESCRIPTIVE STATISTICS
# ==========================================

cat("\nAVERAGE HOUSEHOLD SIZE:\n")
print(mean(household_data$Household_Size))

cat("\nAVERAGE ELECTRICITY CONSUMPTION:\n")
print(mean(
  household_data$Monthly_Electricity_Consumption_kWh
))

cat("\nAVERAGE MONTHLY ELECTRICITY BILL:\n")
print(mean(
  household_data$Monthly_Electricity_Bill_PHP
))

cat("\nHIGHEST MONTHLY ELECTRICITY BILL:\n")
print(max(
  household_data$Monthly_Electricity_Bill_PHP
))

cat("\nLOWEST MONTHLY ELECTRICITY BILL:\n")
print(min(
  household_data$Monthly_Electricity_Bill_PHP
))

cat("\nENERGY SAVING PRACTICES:\n")
print(table(household_data$Energy_Saving_Practice))

# ==========================================
# 5. SUMMARY TABLE
# ==========================================

summary_results <- data.frame(
  Statistic = c(
    "Average Household Size",
    "Average Electricity Consumption",
    "Average Monthly Electricity Bill",
    "Highest Monthly Electricity Bill",
    "Lowest Monthly Electricity Bill"
  ),
  
  Result = c(
    round(mean(household_data$Household_Size), 2),
    round(mean(
      household_data$Monthly_Electricity_Consumption_kWh
    ), 2),
    round(mean(
      household_data$Monthly_Electricity_Bill_PHP
    ), 2),
    max(household_data$Monthly_Electricity_Bill_PHP),
    min(household_data$Monthly_Electricity_Bill_PHP)
  )
)

cat("\nSUMMARY RESULTS:\n")
print(summary_results)

write.csv(
  summary_results,
  "electricity_summary.csv",
  row.names = FALSE
)

# ==========================================
# 6. GRAPH 1
# ELECTRICITY CONSUMPTION BY HOUSEHOLD SIZE
# ==========================================

graph1 <- ggplot(
  household_data,
  aes(
    x = factor(Household_Size),
    y = Monthly_Electricity_Consumption_kWh,
    fill = factor(Household_Size)
  )
) +
  
  geom_boxplot(alpha = 0.85) +
  
  scale_fill_brewer(palette = "Blues") +
  
  labs(
    title = "Electricity Consumption by Household Size",
    x = "Number of Household Members",
    y = "Monthly Consumption (kWh)"
  ) +
  
  theme_minimal(base_size = 12) +
  
  theme(
    plot.title = element_text(
      color = "#315F8A",
      face = "bold",
      size = 14
    ),
    axis.title = element_text(color = "#315F8A"),
    axis.text = element_text(color = "#45566B"),
    legend.position = "none",
    panel.grid.minor = element_blank()
  )

print(graph1)

ggsave(
  "graph1_consumption_by_household.png",
  graph1,
  width = 8,
  height = 5,
  dpi = 300
)

# ==========================================
# 7. GRAPH 2
# MONTHLY ELECTRICITY EXPENSES
# ==========================================

graph2 <- ggplot(
  household_data,
  aes(x = Monthly_Electricity_Bill_PHP)
) +
  
  geom_histogram(
    bins = 10,
    fill = "#477EAF",
    color = "white",
    alpha = 0.9
  ) +
  
  labs(
    title = "Distribution of Monthly Electricity Expenses",
    x = "Monthly Electricity Bill (PHP)",
    y = "Number of Households"
  ) +
  
  theme_minimal(base_size = 12) +
  
  theme(
    plot.title = element_text(
      color = "#315F8A",
      face = "bold",
      size = 14
    ),
    axis.title = element_text(color = "#315F8A"),
    axis.text = element_text(color = "#45566B"),
    panel.grid.minor = element_blank()
  )

print(graph2)

ggsave(
  "graph2_monthly_electricity_expenses.png",
  graph2,
  width = 8,
  height = 5,
  dpi = 300
)

# ==========================================
# 8. GRAPH 3
# ENERGY-SAVING PRACTICES
# ==========================================

graph3 <- ggplot(
  household_data,
  aes(
    x = Energy_Saving_Practice,
    fill = Energy_Saving_Practice
  )
) +
  
  geom_bar(
    width = 0.6,
    alpha = 0.9
  ) +
  
  scale_fill_manual(
    values = c(
      "Yes" = "#399B83",
      "No" = "#8979B9"
    )
  ) +
  
  labs(
    title = "Household Energy-Saving Practices",
    x = "Practices Energy Saving?",
    y = "Number of Households"
  ) +
  
  theme_minimal(base_size = 12) +
  
  theme(
    plot.title = element_text(
      color = "#315F8A",
      face = "bold",
      size = 14
    ),
    axis.title = element_text(color = "#315F8A"),
    axis.text = element_text(color = "#45566B"),
    legend.position = "none",
    panel.grid.minor = element_blank()
  )

print(graph3)

ggsave(
  "graph3_energy_saving_practices.png",
  graph3,
  width = 8,
  height = 5,
  dpi = 300
)

# ==========================================
# 9. FINAL ANALYSIS REPORT
# ==========================================

cat("\n====================================\n")
cat("ANALYSIS COMPLETED SUCCESSFULLY!\n")
cat("====================================\n")

cat("\nThree graphs generated:\n")
cat("1. Consumption by Household Size\n")
cat("2. Monthly Electricity Expenses\n")
cat("3. Energy-Saving Practices\n")

cat("\nSummary file created:\n")
cat("electricity_summary.csv\n")

cat("\nHOUSEHOLD ELECTRICITY ANALYSIS FINISHED!\n")

