library(anytime)
library(ggplot2)
library(lubridate)
# load data
CV.questions <- read.csv("data/questions_with_body.csv",
                        header=TRUE, sep=",")
CV.questions <- transform(CV.questions,
                         date.on.CV = pmax(creation_date,
                                           ifelse(is.na(migrated_from_on_date),
                                                  -1,
                                                  migrated_from_on_date)))
CV.questions <- transform(CV.questions,
                         tag.count=lengths(strsplit(as.character(tags),",")))

#window.days <- 15
window.days <- 182
#tag <- "neural-networks"
#tag <- "machine-learning"
#tag <- "r"
tag <- "regression"

min.t <- ceiling_date(anytime(min(CV.questions$date.on.CV),asUTC = TRUE),
                      unit="day")
max.t <- floor_date(anytime(max(CV.questions$date.on.CV),asUTC = TRUE),
                    unit="day")

day.1 <- min.t + days(window.days)
day.n <- max.t - days(window.days)

question.count <- data.frame()

day.i <- day.1
while (day.i <= day.n){
  
  window.boundaries <- c(as.numeric(as.POSIXct(day.i)) -
                           86400 * window.days, as.numeric(as.POSIXct(day.i)) +
                           86400 * (window.days + 1) )
  
  questions.in.window <-
    CV.questions[ which(CV.questions$date.on.CV > window.boundaries[1] &
                         CV.questions$date.on.CV < window.boundaries[2]),]
  
  q.count <- nrow(questions.in.window)
  all.tags <- sum(questions.in.window$tag.count)
  
  n.tag <- sum(match(strsplit(paste(as.character(questions.in.window$tags),
                                    collapse=","),",")[[1]],tag),na.rm = TRUE)
  
  rbind(question.count,data.frame(day=day.i,
                                  count=q.count,
                                  all.tags=all.tags,
                                  n.tag = n.tag))->question.count
  
  day.i <- day.i + days(1)
}

img.file.name <-
  sprintf("images/questions_in_%d_days.svg",
          2*window.days+1)
svg(img.file.name, width=7, height=4)
plot(question.count$day,
     question.count$count,
     type="l",
     main=sprintf("Πλήθος ερωτήσεων\n ανά %d ημέρες",2*window.days+1),
     xlab="ημερομηνία",
     ylab="πλήθος ερωτήσεων")
dev.off()

#img.file.name <-
#  sprintf("images/tags_in_%d_days.svg",
#          2*window.days+1)
#svg(img.file.name, width=7, height=4)
#plot(question.count$day,
#     question.count$all.tags,
#     type="l",
#     main=sprintf("number of tags\n in a %d day window",2*window.days+1),
#     xlab="date",
#     ylab="number of tags")
#dev.off()

img.file.name <-
  sprintf("images/tag_%s_in_%d_days.svg",
          tag, 2*window.days+1)
svg(img.file.name, width=7, height=4)
plot(question.count$day,
     question.count$n.tag/question.count$count,
     type="l",
     main=sprintf("ερωτήσεις με την ετικέτα \"%s\"\n (χρονικό παράθυρο %d ημερών)",
                  tag,
                  2*window.days+1),
     xlab="ημερομηνία",
     ylab="σχετική συχνότητα")
dev.off()
