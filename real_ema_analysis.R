# ================================================
# NSMD PhD Mini Prototype - Real EMA Analysis
# Bringmann et al. (2013) depression ESM data
# ================================================

library(dplyr)
library(qgraph)
library(ggplot2)
library(tidyr)

# 1. Loading + preparing data
real_data <- read.csv("pone.0060188.s004.txt", stringsAsFactors = FALSE)

colnames(real_data)[which(colnames(real_data) %in% 
                            c("opgewkt_", "onplplez", "pieker", "angstig_", "somber__", "ontspann"))] <- 
  c("Cheerful", "Pleasant", "Worry", "Anxious", "Sad", "Relaxed")

symptoms <- c("Cheerful", "Pleasant", "Worry", "Anxious", "Sad", "Relaxed")

# 2. Listwise deletion + split by phase
complete_data <- real_data[complete.cases(real_data[symptoms]), ]
pre_data      <- complete_data %>% filter(st_period == 0)
during_data   <- complete_data %>% filter(st_period == 1)

cat("Complete cases:", nrow(complete_data), "\n")
cat("Pre phase:", nrow(pre_data), " | During phase:", nrow(during_data), "\n")

# 3. Function to create and save network
estimate_and_plot <- function(data_subset, title) {
  cor_mat <- cor(data_subset[symptoms], use = "pairwise.complete.obs")
  
  pdf(paste0(title, "_network.pdf"), width = 7, height = 7)
  qgraph(cor_mat, layout = "spring", title = title, 
         labels = symptoms, threshold = 0.1, edge.labels = TRUE)
  dev.off()
  
  return(cor_mat)
}

# Generate networks
full_cor    <- estimate_and_plot(complete_data, "One-time_Full_EMA")
pre_cor     <- estimate_and_plot(pre_data,      "Pre_Intervention")
during_cor  <- estimate_and_plot(during_data,   "During_Intervention")

# 4. Simple strength centrality (robust fallback)
strength_pre    <- rowSums(abs(pre_cor), na.rm = TRUE) - 1
strength_during <- rowSums(abs(during_cor), na.rm = TRUE) - 1

# 5. Centrality plot
centr_df <- data.frame(
  Symptom = symptoms,
  Pre     = strength_pre,
  During  = strength_during
) %>%
  pivot_longer(cols = c(Pre, During), names_to = "Phase", values_to = "Strength")

ggplot(centr_df, aes(x = reorder(Symptom, Strength), y = Strength, fill = Phase)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(title = "Strength Centrality: Pre vs During Intervention",
       subtitle = "Real EMA data (Bringmann et al. 2013 mindfulness trial)",
       y = "Strength Centrality",
       x = "",
       caption = "Note: ~59% missingness handled with listwise deletion") +
  scale_fill_manual(values = c("Pre" = "#1f77b4", "During" = "#ff7f0e"))

ggsave("Centrality_Change_Real_Data.pdf", width = 10, height = 7)

cat("All files generated successfully!\n")
