library(anytime)

answer_summary <- read.csv("data/answer_summary.csv")

as.numeric(as.POSIXct(answer_summary$creation_date_answer)) - answer_summary$date_on_CV

accepted_answers <- answer_summary[which(answer_summary$is_accepted==TRUE &
                                           as.numeric(as.POSIXct(answer_summary$creation_date_answer)) -
                                           answer_summary$date_on_CV > 0),]

#accepted_times <- (as.numeric(as.POSIXct(accepted_answers$creation_date_answer))
#                   - accepted_answers$date_on_CV) / 60

#svg("images/time_to_accepted_answer_2h.svg",
#    width=7, height=4)
#hist(accepted_times,
#     breaks=seq(-10000000,10000000,10),
#     col=gray(0.5),
#     main="Time to accepted answer\nfirst 2h",
#     xlab="Time (min)",
#     ylab="Relative frequency",
#     xlim=c(0,120),
#     freq=FALSE)
#dev.off()

accepted_times <- (as.numeric(as.POSIXct(accepted_answers$creation_date_answer))
                   - accepted_answers$date_on_CV) / 3600

svg("images/time_to_accepted_answer_1_day.svg",
    width=7, height=4)
hist(accepted_times,
     breaks=seq(-10000000,10000000,1),
     col=gray(0.5),
     main="Χρόνος μέχρι την πρώτη αποδεκτή απάντηση",
     xlab="Χρόνος (h)",
     ylab="Σχετική συχνότητα",
     xlim=c(0,25),
     freq=FALSE)
dev.off()

#accepted_times <- (as.numeric(as.POSIXct(accepted_answers$creation_date_answer))
#                   - accepted_answers$date_on_CV) / 86400

#svg("images/time_to_accepted_answer_1_week.svg",
#    width=7, height=4)
#hist(accepted_times,
#     breaks=seq(-10000000,10000000,1),
#     col=gray(0.5),
#     main="Time to accepted answer\nfirst week",
#     xlab="Time (days)",
#     ylab="Relative frequency",
#     xlim=c(0,7),
#     freq=FALSE)
#dev.off()

#x_step <- stepfun(sort(accepted_times),c(0,1:length(accepted_times) / length(unique(answer_summary$question_id))))
#svg("images/time_to_accepted_answer_step.svg",
#    width=7, height=4)
#plot(x_step,
#     xlim=c(0,7),
#     xaxs="i",
#     yaxs="i",
#     lwd=3,
#     col="red",
#     main="getting an accepted answer",
#     xlab = "Time (days)",
#     ylab = "Probability")
#dev.off()

#svg("images/time_to_accepted_answer_step_log.svg",
#    width=7, height=4)
#plot(x_step,
#     xlim=c(0.01,100),
#     xaxs="i",
#     yaxs="i",
#     lwd=3,
#     col="red",
#     main="getting an accepted answer",
#     xlab = "Time (days)",
#     ylab = "Probability",
#     log="x")
#dev.off()


