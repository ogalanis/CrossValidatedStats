library(anytime)
library(ggplot2)

# load data
CV.questions <- read.csv("data/questions_with_body.csv",
                        header=TRUE, sep=",")

svg("images/answer_count_histogram.svg",
    width=7, height=5)
# plain histogram with answers per question
hist(CV.questions$answer_count,
     xlim=c(0,10),
     breaks=seq(-0.5,max(CV.questions$answer_count)+0.5,1 ),
     prob = TRUE, col=gray(0.5),
     main="Απαντήσεις ανά ερώτηση",
     xlab="πλήθος απαντήσεων",
     ylab="σχετική συχνότητα")
dev.off()

# convert creation time from UNIX time to string.
# Do not include date
t <- strftime(anytime(CV.questions$creation_date,asUTC=TRUE),format="%H-%M-%S")
# convert string to POSIX time
timeofday <- as.POSIXct(t, tz="UTC", format="%H-%M-%S")
# plot histogram with creation time
svg("images/question_creation_times_histogram.svg",
    width=7, height=4)
hist(timeofday,
     breaks="hours",
     col=gray(0.5),
     main="Ώρες υποβολής ερωτήσεων",
     xlab="ώρα (UTC)",
     ylab="συχνότητα",
     freq=TRUE)
dev.off()

# plot histogram with tags
all.tags <- data.frame(table(strsplit(paste(levels(CV.questions$tags),
                                            collapse = ","),",")))
colnames(all.tags) <- c("tag","frequency")
toptags <- head(all.tags[order(all.tags$frequency, decreasing = TRUE),],n=10)

tag.plot <- ggplot(toptags, aes(x=reorder(tag,c(10:1)), y=frequency)) +
  theme(axis.text.y = element_text(face = "bold", size = 18)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs (x="ετικέτα", y="συχνότητα", title="10 δημοφιλέστερες ετικέτες")

svg("images/top_10_tags.svg",
    width=7, height=7)
print(tag.plot)
dev.off()

