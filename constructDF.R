### Please set the working directory to the dataset folder

### load the tsv file of the training set into R
a = readLines("training_set_rel3.tsv")
a[1]
header = strsplit(x=a[1], split = "\t")[[1]]
length(header)
header
a[2]
all_lengths = lapply(a, function(x) length(strsplit(x=x, split = "\t")[[1]]))
head(all_lengths)
head(unlist(all_lengths))
table(unlist(all_lengths))
head(which(unlist(all_lengths)==1))
b = a[13]
strsplit(x=b, split="\t")
Encoding (b) <- "latin1"
strsplit(x=b, split="\t")
all_lengths = lapply(a, function(x)
  {Encoding (x) <- "latin1"
  length(strsplit(x=x, split = "\t")[[1]])})
table(unlist(all_lengths))
head(which(unlist(all_lengths)==28))
length(a)-12258+1
a[12257]
a[12258]

# we are keeping all variables
train = matrix(NA, nrow=length(a)-1, ncol=28)
train = as.data.frame(train)
dim(train)
names(train)=header
names(train)
head(train)
# the following for loop takes a long time
for(i in 2:length(a)){
  b = a[i]
  Encoding (b) <- "latin1"
  c = strsplit(x=b, split = "\t")[[1]]
  train[(i-1), 1:length(c)] = c
}
train[1,]
class(train[1,27])
nchar(train[1,27])

head(which(is.na(train$essay_id)))
missings = sapply(1:ncol(train), function(i) length(which(is.na(train[,i]))))
missings
save(train, file="training_set_20150605.rda")
# rater1 does not have the large score all the time, only 81% of the time
table(train$rater1_domain1 >= train$rater2_domain1)/nrow(train)


### load the tsv file of the testing set into R
a = readLines("test_set.tsv")
header = strsplit(x=a[1], split = "\t")[[1]]
length(header)
header
a[2]

test = matrix(NA, nrow=length(a)-1, ncol=5)
test = as.data.frame(test)
dim(test)
names(test)=header
names(test)
head(test)
# the following for loop might take a long time
for(i in 2:length(a)){
  b = a[i]
  Encoding (b) <- "latin1"
  c = strsplit(x=b, split = "\t")[[1]]
  test[(i-1), 1:length(c)] = c
}
head(test)
missings = sapply(1:ncol(test), function(i) length(which(is.na(test[,i]))))
missings
head(test)
save(test, file="testing_set_20150605.rda")
