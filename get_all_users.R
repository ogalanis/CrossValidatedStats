library(stackr)

users <- stack_users(site="CrossValidated",
                     page=1,
                     pagesize=100,
                     num_pages=1)
# As of 2019, 2300 pages are enough to get all Cross
# Validated users.
#                     num_pages=2300)

write.csv(users,file="data/users.csv")
