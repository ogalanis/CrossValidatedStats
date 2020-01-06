library(stackr)

# Get all answers, up to a specific date
response <- stack_answers(site="CrossValidated",
                          todate=1556668800, # This date is 2019/05/01 00:00:00                          
                          page=1,
                          pagesize=100,
                          num_pages=1)
# As of spring 2019, 1500 pages are enough for all questions
#                          num_pages=1500)
                          
write.csv(response,"data/answers.csv")
