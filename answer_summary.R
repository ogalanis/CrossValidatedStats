library(dplyr)
library(data.table)

answers <- read.csv("data/answers.csv")

questions <- read.csv("data/questions_with_body.csv")

questions_summary <- (questions
                     %>% select(accepted_answer_id,
                                answer_count,
                                creation_date,
                                question_id,
                                owner_user_id,
                                owner_reputation,
                                owner_accept_rate,
                                migrated_from_on_date)
                    %>% transform(date_on_CV = pmax(creation_date,
                                                    ifelse(is.na(migrated_from_on_date),
                                                           -1,
                                                           migrated_from_on_date))))


answer_summary <- right_join(answers,
                            questions_summary,
                            by="question_id",
                            suffix=c("_answer","_question"))

write.csv(answer_summary,"data/answer_summary.csv", row.names = FALSE)
