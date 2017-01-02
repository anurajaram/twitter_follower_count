# author - Anupama Rajaram
# Date - Jan 2, 2017
# Description - Get details about the people who follow me using the follower-ids.
#               Follower-ids were extracted using program "get_tw_folwr_ids.R" and
#               stored in file "analytics_followers_jan2_2017.csv"



# call library packages
source("init_srcfile.R")

# initialize basic url for API calls
url_p1 = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=10&exclude_replies=TRUE&screen_name="

tweetdf = data.frame()
tempdf = data.frame()

# read the names of people I follow from the file "Ann_is_following.csv"
# This file was created using the program code in file "who_iam_following.R"
arr = data.frame(fread("Ann_is_following.csv"))


for(i in 2:nrow(arr)){
  
  if(i%%20 == 0){
    print(paste("this is iteration for record", i))
  }
  
  tempdf = arr[i,]
  #urlpath = paste(url_p1, tempdf$id, url_p2, tempdf$scrnm, sep = "")
  urlpath = paste(url_p1, tempdf$scrnm, sep = "")
  
  # get data from Twitter API
  outresp = GET( urlpath ,sig)
  
  # process the json received as output
  jsresp <- httr::content(outresp)
  
  # if tweets are available, store to array
  #if((length(jsresp) > 0) & (jsresp$error != "Not authorized.")){
  if(length(jsresp) > 0){    
    for( ptr in 1:length(jsresp)){
      
      xdf = data.frame( lname = tempdf$scrnm, 
                        date_creation = jsresp[[ptr]]$created_at, 
                        tweet_text = jsresp[[ptr]]$text,
                        rtcount = jsresp[[ptr]]$retweet_count,
                        favct = jsresp[[ptr]]$favorite_count,
                        favflag = jsresp[[ptr]]$favorited,
                        rtflag = jsresp[[ptr]]$retweeted)
      
      tweetdf = rbind(tweetdf, xdf)
    }
  }
  
}


# convert the date to a usable format
tweetdf$datearr = as.vector(tweetdf$date_creation)
tweetdf$datearr = substr(tweetdf$datearr, 5, 30)  # removing the "weekday" part.
tweetdf$mthname = substr(tweetdf$datearr, 1, 3)
tweetdf$dayofmth = substr(tweetdf$datearr, 5, 6)
tweetdf$time = substr(tweetdf$datearr, 7, 15)
tweetdf$year = substr(tweetdf$datearr, 23, 26)
tweetdf$mth_as_num = as.numeric(factor(tweetdf$mthname , 
                            levels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")))
tweetdf$newdate = paste(tweetdf$mth_as_num, tweetdf$dayofmth, tweetdf$year,
                        sep = "-")


write.table(tweetdf, file = "TweetStorenow.csv", row.names = FALSE, append = TRUE)


