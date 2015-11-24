essayNLP = function(s, essayset){
  # the input s is the essay itself
  # whereas the essayset should be a value between 1 to 8
  # the purpose of essayset is that for different essayset
  # we are automaticlly reading different input files
  require(NLP)
  require(openNLP)
  require(qdap)
  nchar = nchar(s)
  word_ann <- Maxent_Word_Token_Annotator()
  sent_ann <- Maxent_Sent_Token_Annotator()
  s_annotations <- annotate(s, list(sent_ann, word_ann))
  s_doc <- AnnotatedPlainTextDocument(s, s_annotations)
  # since we are repeatly using words(s_doc), sents(s_doc), and df
  # we name it here to avoid dupilicate calculation
  ww = words(s_doc)
  ss = sents(s_doc)
  df = as.data.frame(s_annotations)[1:length(ss), ]
  loopw = sapply(ww,nchar)
  d = df$end - df$start
  loops = sapply(ss,length)
  # the function in openNLP package and qdap package
  # requires the input to be a string instead of char
  s = as.String(s)
  # the following the the system to calculate the NLP structures
  # of the input essay
  anno = Annotation(1L, "sentence", 1L, nchar(s))
  anno = annotate(s, word_ann, anno)
  anno2 = annotate(s, Maxent_POS_Tag_Annotator(), anno)
  an_w = anno2[anno2$type == "word"]
  POStags = unlist(lapply(an_w$features, `[[`, "POS"))
  POStagged = unique(paste(sprintf("%s/%s", s[an_w], POStags)))
  tag_table = table(gsub(".*/", "", POStagged))
  adj = max(sum(tag_table[grepl("J.*", names(tag_table))]), 0)
  n = max(sum(tag_table[grepl("N.*", names(tag_table))]), 0)
  adv = max(sum(tag_table[grepl("RB.*", names(tag_table))]),0)
  v = max(sum(tag_table[grepl("RB.*", names(tag_table))]), 0)
  conjunction = max(sum(tag_table[grepl("CC", names(tag_table))]), 0)
  # at this point, we finished section 3.2 in the paper
  # the following codes are for 3.3
  # we read the description file based on input essaysef
  # and use NLP to select important keys words from the
  # description file
  description = paste0("es",essayset,".txt")
    
  tt=readLines(description)
  if (length(grep('^Source Essay', tt))==0){
    i=grep('^Prompt', tt)[1]+1
    j = grep('Rubric Guidelines', tt)[1]-1
  }else{
      i= grep('^Source Essay', tt)[1]+1
      j = grep('^Prompt', tt)[1]-1
  }
  prompt= tt[i:j]
  # found the part that we want in the description file
  prompt = as.String(prompt)
  word_token_annotator = Maxent_Word_Token_Annotator()
  anno = Annotation(1L, "sentence", 1L, nchar(prompt))
  anno = annotate(prompt, word_token_annotator, anno)
  anno2 = annotate(prompt, Maxent_POS_Tag_Annotator(), anno)
  an_w = anno2[anno2$type == "word"]
  
  word = unique(prompt[an_w][grep("^N.*", unlist(lapply(an_w$features, `[[`, "POS")))])
  if(length(word)>20)
    word = word[sample(length(word), 10)]  #get the key word
  # these words from the description files are what we except to be important
  # now we return to our original input string s,
  # which is the essay itself
  # the following code is to see the overlapness between the title description a
  # and essay itself
  freq = as.data.frame(table(unlist(sents(body_doc))), stringsAsFactors = FALSE)
  
  Str = unique(c(word, unique(unlist(synonyms(word, report.null = FALSE)))))
  sum = 0
  for (i in 1:length(Str)) #can not find pharse
    sum = sum + sum(freq$Var1 ==Str[i])
  
  title_connection = sum/word_number
  # title connection is a ratio 
  word_freq_list = c() 
  for(i in 1:length(unique(ww)))
    word_freq_list[i] = mean(which(freq$Var1[i] == unlist(sents(body_doc)))) #the position of each word
  headtailconn = sum(word_freq_list >= word_number/2-word_number/4 & word_freq_list >= word_number/2+word_number/4)
  # above code is to see how similar the beginning quarter and the last quarter of the essay are like
  # the intent is to extract some structure of information about good structure of the essay
  # now we are done, construct the following df
  answer = list(
    nchar = nchar,
    number_of_words = length(ww),
    number_of_unique_words = length(unique(ww)),
    number_of_sents = length(ss),
    
    mean_word_length = mean(loopw),
    median_word_length = median(loopw),
    sd_word_length = sd(loopw),
    
    mean_sent_length_in_char = mean(d),
    median_sent_length_in_char = median(d),
    sd_sent_length_in_char = sd(d),
    
    mean_sent_length_in_word = mean(loops),
    median_sent_length_in_word = median(loops),
    sd_sent_length_in_word = sd(loops),
    
    num_colon = sum(ww == ":"),
    num_comma = sum(ww == ","),
    num_exc = sum(ww == "!"),
    num_que = sum(ww == "?"),
    
    adj = adj, 
    n = n,
    adv = adv,
    v = v,
    conjuction = conjunction,
    
    title_connection = title_connection,
    headtailconn = headtailconn
  )
  # we replace NA with 0.
  # this doesn't actually happen
  # it is just a safer way to get useable features
  answer[is.na(answer)]=0
  return(answer)
}

# the following code is the for loop that put all features 
# for all essays in a essayset
# notice this takes a long time to run
# on average, it takes 2.5 seconds to process one essay
feature1models = function(essayset, train){
  train = train[index, ]
  essay1train = train[train$essay_set == essayset, ]
  s = train$essay[2]
  b = essayNLP(s, essayset)
  essay1train = essay1train[ ,c(7,3)]
  tmp = matrix(-1.0, nrow=nrow(essay1train), length(b))
  essay1train = cbind(essay1train, tmp)
  names(essay1train)[3:(length(b)+2)] = names(b)
  essay1train$domain1_score = as.integer(essay1train$domain1_score)
  for(i in 1:nrow(essay1train)){
    f = essayNLP(essay1train$essay[i],essayset)
    essay1train[i, 3:length(essay1train)] = unlist(f)
    cat("             \r")
    cat(i)
  }
  return(essay1train)
}

