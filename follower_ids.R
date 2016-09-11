# author - Anupama Rajaram
# Date - September 7, 2016
# Description - Get Follower ids using Twitter API and cursor pagination

# call source file with all required packages.
source("workspace_prep.R")
library("twitteR")
library("data.table")
library(httr)
library(jsonlite)
options(scipen = 999)
library(rjson)
library(RJSONIO)

# set variables for twitter API call authorization
consumer_key = "1aca"
consumer_secret = "Wyca"
access_token = "33-Caca"
access_secret = "Ygca"

options(httr_oauth_cache=T) 


# sign using twitter token and token secret
myapp = oauth_app("twitter", key=consumer_key, secret=consumer_secret)
sig = sign_oauth1.0(myapp, token=access_token, token_secret=access_secret)


# initialidze dataframe to store follower ids
idlistfull <- data.frame(Follower_ids = 0)


# initialize cursor value and basic url for API calls
# we are currently getting follower ids for account = @hadleywickham
cursor = -1
api_path1 = "https://api.twitter.com/1.1/followers/ids.json?cursor="
api_path2 = "&screen_name=anu_analytics&count=5000"
iter_num = 1

idlistfull <- data.frame(num = 0, ids= 0)

# using a while loop to perform pagination when return list contains >5000 ids.
while ( cursor != 0 ) {
  # to indicate the program is working, print the iteration number & current cursor value  
  print("current iteration = " ) 
  print(iter_num)
  print("current cursor value = " ) 
  print(cursor)
  
  # create the composite url to call data from Twitter API.
  url_with_cursor = paste(api_path1, cursor, api_path2, sep = '')
  outresp = GET( url_with_cursor ,sig)
  
  # process the json received as output
  jsresp <- httr::content(outresp)
  jsxresp <- data.frame(num = c(1:length(jsresp$ids)))
  jsxresp$ids <- as.character( jsresp$ids)
  #jsresp <- content(outresp)
  #jsxresp <- jsonlite::toJSON(outresp)
#   idlist <- as.data.frame(jsxresp)
#   colnames(idlist) <- c("Follower_ids")
  
  # append the follower ids from this iteration to master follower list.
  idlistfull <- rbind(idlistfull, jsxresp)
  
  # update cursor to point to next cursor
  cursor = jsresp$next_cursor
  
  # update iteration number by 1.
  iter_num = iter_num + 1
}

# convert the ids from list to character
idlistfull$ids <- unlist(idlistfull$ids)

# write list of follower ids to Excel file.
write.csv(idlistfull, file = "analytics_followers.csv", row.names = FALSE)





