library(stackr)
library(dplyr)

# Get all questions, including question body, up to a specific date
questions <- stack_questions(site="CrossValidated",
                             todate=1556668800, # This date is 2019/05/01 00:00:00
                             page=1,
                             pagesize=100,
                             num_pages=1,
# As of spring 2019, 1400 pages are enough for all questions
#                             num_pages=1400,
                             filter="withbody")

# Clean up the question bodies
questions <- transform(questions,
                       body=(body
                             %>% gsub("<blockquote>.*?</blockquote>", "", .)
                             %>% gsub("<code>.*?</code>", "", .)
                             %>% gsub("<span class=\"math-container\">.*?</span>",
                                      "", .)
                             %>% gsub("<.*?>", "", .)
                             %>% gsub("\\$\\$.*?\\$\\$", "", .)
                             %>% gsub("\\$.*?\\$", "", .)
                             ))

questions <- apply(questions, 2, as.character)

write.csv(questions,
          "data/questions_with_body.csv")
