library(dplyr)
library(ggplot2)

user_page_rank <- read.csv("data/user_page_rank.csv")

user_reputation <-
  read.csv("data/users.csv") %>%
  select(user_id,reputation)

user_page_rank <- left_join(user_page_rank,user_reputation,by="user_id")

img_file_name <- "images/reputation_vs_page_rank.svg"
svg(img_file_name, width=7, height=7)
scatter_plot <- ggplot(user_page_rank, aes(x=page_rank,y=reputation)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10() +
  labs(x="PageRank", y="βαθμολογία (reputation)", title="βαθμολογία (reputation) vs PageRank")
print(scatter_plot)
dev.off()
