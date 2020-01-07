
users <- read.csv("data/users.csv")

log_rep <- log10(users$reputation)
log_N <- log10(rank(-users$reputation,ties.method="max"))

svg("images/reputation_distribution.svg",
    width=7, height=7)
plot(log_rep,
     log_N,
     main="κατανομή της βαθμολογίας των χρηστών",
     xlab = "log(βαθμολογία)",
     ylab = "log(αθροιστική συχνότητα)")
dev.off()
