library(dplyr)
library(igraph)

answer_summary <- read.csv("data/answer_summary.csv")

user_interactions <- select(answer_summary,owner_user_id_question,owner_user_id_answer)

user_interactions <-
  user_interactions[which( (! is.na(user_interactions$owner_user_id_question)) &
                             (! is.na(user_interactions$owner_user_id_answer))), ]

interaction_graph <- make_graph(c(as.character(t(user_interactions))),directed=FALSE)

user_page_rank <- -sort(-page_rank(interaction_graph)$vector)

user_page_rank <- data_frame(as.numeric(attributes(user_page_rank)$names),user_page_rank)

colnames(user_page_rank) <- c("user_id","page_rank")

write.csv(user_page_rank,"data/user_page_rank.csv")

d <- degree(interaction_graph)

interaction_vertices <- V(interaction_graph)
interaction_graph_2 <- delete_vertices(interaction_graph,interaction_vertices[which(d<50)])


plot(interaction_graph_2)

#eb_groups <- cluster_edge_betweenness(interaction_graph_2)
#aggregate(data.frame(count = eb_groups$membership), list(value=eb_groups$membership), length)

lo_groups <- cluster_louvain(interaction_graph_2)
aggregate(data.frame(count = lo_groups$membership), list(value=lo_groups$membership), length)




#interaction_clusters <- clusters(interaction_graph)

#plot(cumsum(seq(0,4205) * 53597 * degree_distribution(interaction_graph)))


