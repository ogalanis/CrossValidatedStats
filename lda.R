library(dplyr)
library(tidytext)
library(topicmodels)
library(ggplot2)
library(tidyr)
library(SnowballC)
library(reshape2)

#harmonicMean <- function(logLikelihoods, precision = 2000L) {
#  llMed <- median(logLikelihoods)
#  as.double(llMed - log(mean(exp(-logLikelihoods + llMed))))
#}

ntopics <- 5

CV.questions <-
#  read.csv("data/questions_with_body.csv.orig",
  read.csv("data/questions_with_body.csv",
           header=TRUE, sep=",")

#CV.questions <- transform(CV.questions, body = gsub("\\n"," ",body))
#CV.questions <-
#  transform(CV.questions,
#            body = gsub("<span class=\"math-container\">.*?</span>","",body))
#CV.questions <- transform(CV.questions, qbody = gsub("<.*?>","",body))

#tidy.words <- (select(CV.questions,c("question_id","title"))
#               %>% transform(title=as.character(title))
#               %>% unnest_tokens(word,title))

tidy.words <- (select(CV.questions,c("question_id","body")))

rm(CV.questions)

gc()
               
tidy.words <- transform(tidy.words, body=as.character(body))

tidy.words <- transform(tidy.words, body= gsub("&.*;", " ", body))

tidy.words <-  (transform(tidy.words, body= gsub("[^[:alpha:][:space:]]+", " ", body)) %>%
               unnest_tokens(word,body))

tidy.words <- (tidy.words %>% anti_join(stop_words))

tidy.words <- transform(tidy.words, word=wordStem(word, language="english"))

tidy.words.1 <- full_join(count(tidy.words,question_id),tidy.words) %>% subset(.,n>=0) %>% select(c("question_id","word"))
#tidy.words.2 <- full_join(count(tidy.words,question_id),tidy.words) %>% subset(.,n<50) %>% select(c("question_id","word"))

write.csv(tidy.words,"data/tidy_words.csv")

nq <- tidy.words.1["question_id"] %>% unique() %>% count()
q_max <- as.numeric(nq*1.1)
q_min <- 20

unique.question.words <- tidy.words.1[c("question_id","word")] %>% unique() %>% count(.,word)
my.stop.words <- subset(unique.question.words,(n < q_min | n > q_max))

tidy.words.1 <- anti_join(tidy.words.1, my.stop.words, by="word")

word.counts.1 <- (tidy.words.1 %>% count(.,question_id,word,sort=TRUE))
#word.counts.2 <- (tidy.words.2 %>% count(.,question_id,word,sort=TRUE))

rm(tidy.words)
gc()

ungroup(word.counts.1)
#ungroup(word.counts.2)

questions.dtm.1 <- word.counts.1 %>% cast_dtm(question_id,word,n)
#questions.dtm.2 <- word.counts.2 %>% cast_dtm(question_id,word,n)

rm(word.counts.1)
#rm(word.counts.2)
gc()

#burnin <- 1000
#iter <- 1000
#keep <- 50

questions.lda.1 <- LDA(questions.dtm.1,
                       k=ntopics,
                       method="Gibbs",
                       control = list(seed=1234,
                                      verbose=10))
#
#                                      burnin=burnin,
#                                      iter=iter,
#                                      keep=keep))

#questions.lda.2 <- posterior(questions.lda.1, questions.dtm.2)

questions.topics <- tidy(questions.lda.1, matrix="beta")

csv.file.name <-
  sprintf("data/terms_for_%d_topics.csv", ntopics)
write.csv(questions.topics,csv.file.name)

#documents.topics.2 <- melt(questions.lda.2[[2]])
#names(documents.topics.2) <- c("document","topic","gamma")

documents.topics.1 <- tidy(questions.lda.1, matrix="gamma")

#documents.topics.all <- rbind(documents.topics.1,documents.topics.2)
documents.topics.all <- documents.topics.1

csv.file.name <-
  sprintf("data/question_topics_for_%d_topics.csv", ntopics)
write.csv(documents.topics.all,csv.file.name)

questions.top.terms <- (questions.topics
                        %>% group_by(topic)
                        %>% top_n(10,beta)
                        %>% ungroup()
                        %>% arrange(topic,-beta))

img.height <- 3 * ( ((ntopics-1) %/% 3) + 1 )
img.file.name <-
  sprintf("images/terms_for_%d_topics.svg", ntopics)
svg(img.file.name, width=7, height=img.height)
top.terms.plot <- (questions.top.terms
                   %>% mutate(term=reorder(term,beta))
                   %>% ggplot(aes(term,beta,fill = factor(topic))) +
                     geom_col(show.legend=FALSE) +
                     facet_wrap(~ topic,scales="free") +
                     coord_flip()) +
                     labs(x="όρος",y="β" )
print(top.terms.plot)
dev.off()

#beta.spread <- (questions.topics
#                %>% mutate(topic=paste0("topic",topic ))
#                %>% spread(topic,beta)
#                %>% filter(topic1> .001 | topic2 > .001)
#                %>% mutate(log_ratio=log2(topic2/topic1)))
