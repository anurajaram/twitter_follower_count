# author - Anupama Rajaram
# Date - August 7, 2016
# Description - Get Follower id username 
#               Follower ids were extracted using program "get_twitter_followers_id.R"
#               using Twitter API and cursor pagination



# call source file with all required packages.
source("C:/anu/data analytics/twitter API - aug 2016/workspace_prep.R")
library("twitteR")
library("data.table")
library(httr)
library(jsonlite)
options(scipen = 999)
library(rjson)
library(RJSONIO)


# set variables for twitter API call authorization
consumer_key = "ann"
consumer_secret = "ann"
access_token = "101-sss"
access_secret = "jjj"
options(httr_oauth_cache=T) 


# sign using twitter token and token secret
myapp = oauth_app("twitter", key=consumer_key, secret=consumer_secret)
sig = sign_oauth1.0(myapp, token=access_token, token_secret=access_secret)


# initialidze dataframe to store details about follower ids
jsfoll <- data.frame(idnum = 0, scr_name = "empty_placeholder", 
                      folnum = 0, geo = "Philadelphia" , stringsAsFactors = FALSE)
jsxresp <- data.frame(idnum = 0, scr_name = "empty_placeholder", 
                      folnum = 0, geo = "Philadelphia" , stringsAsFactors = FALSE)


# initialize basic url for API calls
api_path1 = "https://api.twitter.com/1.1/users/lookup.json?user_id="


# read list of follower ids from stored file. 
# this file was generated using the program "follower_ids.R"
folwr_list <- fread("analytics_followers.csv")

lenct <- length(folwr_list$num)
# using a while loop to perform pagination when return list contains >5000 ids.
for( i in 2:lenct) 
{
  # to indicate the program is working, print a statement for every 100th iteration.
  if((i %% 100) == 0 )
  {
    print(paste("current iteration = ", i ) )
  }
  
  # store row 'i' of the follower_list table into a temporary array.
  temparray <- folwr_list[i,]
  
  # create the composite url to call data from Twitter API.
  url_with_cursor = paste(api_path1, temparray$ids, sep = '')
  outresp = GET( url_with_cursor ,sig)
  
  # if status code is 429, then you have exceeded API rate limit for today.
  # hence print a WARNING statement, and exit loop. 
  if(outresp$status_code == 200)
  {
    print("API daily rate exceeded - please try tomorrow or with new account.")
    break
  }
  
  # if status code is 200, then entry is a valid user.
  # hence process the json received as output
   if(outresp$status_code == 200)
   {
    #print("hello")
    jsresp <- httr::content(outresp)
    jsxresp <- data.frame(idnum = jsresp[[1]]$id, scr_name = jsresp[[1]]$screen_name, 
                          folnum = jsresp[[1]]$followers_count,
                          geo = jsresp[[1]]$location, stringsAsFactors = FALSE)
   #print(paste("jsxresp = ", jsxresp$scr_name))
    
    jsfoll <- rbind(jsfoll, jsxresp)
  }
}    

# write list of follower ids to text file.
write.csv(jsfoll, file = "anu_folr_names_new.csv", row.names = FALSE)

# output image added to repo.

