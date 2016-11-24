# author - Anupama Rajaram
# Date - Nov 24, 2016
# Description - Get ids of people I follow on Twitter, using Twitter API and cursor pagination

rm(list=ls(all=TRUE))

# i prefer <5 decimal places
options(digits=4)

# suppress scientific notation e.g.: 2.4e5 instead 2,400,367 
options(scipen = 999)


# load standard library packages: (you can also save this package list in a source file)
library(data.table)   # for fread() 
library(bit64)
library(plyr)

library(plotly)
library(htmltools)
library(ggvis)

library('ggplot2')    # plotting data

library("twitteR")
library(httr)
library(jsonlite)
library(rjson)
library(RJSONIO)

# set variables for twitter API call authorization
# please use your own Twitter API authorization
consumer_key = "abcde"
consumer_secret = "zyxwvu"
access_token = "1133-pqrst"
access_secret = "lmnop"

options(httr_oauth_cache=T) 


# sign using twitter token and token secret
  myapp = oauth_app("twitter", key=consumer_key, secret=consumer_secret)
  sig = sign_oauth1.0(myapp, token=access_token, token_secret=access_secret)
  
  
  # initialize dataframes to store follower ids
  # we capture the below detials about the people we follow:
  # realname, screenname (twitter handle), follower count, number of people 
  # they follow and interests/profile description.
  idlistfull <- data.frame(id = 0, name = "name", scrnm = "screename",
                           folr_count = 0, followg = 0,
                           descrp = "description & interests",
                           stringsAsFactors = FALSE)
  followinglist = data.frame(id = 0, name = "name", scrnm = "screename", 
                             folr_count = 0, followg = 0,
                             descrp = "description & interests",
                             stringsAsFactors = FALSE)
  tempdf = data.frame()


# initialize cursor value and basic url for API calls
# we are currently getting follower ids for my account = @anu_analytics
# we break up the url to avoid "hardcoding" the username.
# this also allows us to use cursor pagination. 
# currently this API call only returns 200 "friend" usernames at a time.
cursor = -1
api_path1 = "https://api.twitter.com/1.1/friends/list.json?cursor="
api_path2 = "&screen_name="
api_path3 = "&count=200&skip_status=true&include_user_entities=false"
iter_num = 1
username = "anu_analytics"


# using a while loop to perform pagination when return list contains >200 ids.
while ( cursor != 0 ) {
  # to indicate the program is working, print the iteration number & current cursor value  
  print("current iteration = " ) 
  print(iter_num)
  print("current cursor value = " ) 
  print(cursor)
  
  # create the composite url to call data from Twitter API.
  url_with_cursor = paste(api_path1, cursor, api_path2, username, api_path3, sep = '')
  outresp = GET( url_with_cursor ,sig)
  
  # process the json received as output
  jsresp <- httr::content(outresp)
  jsxresp <- data.frame(num = c(1:length(jsresp$users)))
  
  for(i in 1:length(jsresp$users)){
    tempdf = data.frame(id = jsresp$users[[i]]$id, 
                        name = jsresp$users[[i]]$name, 
                        scrnm = jsresp$users[[i]]$screen_name,
                        folr_count = jsresp$users[[i]]$followers_count, 
                        followg = jsresp$users[[i]]$friends_count,
                        descrp = jsresp$users[[i]]$description)
    followinglist = rbind(followinglist,tempdf)
  }
  
  # update cursor to point to next cursor
  cursor = jsresp$next_cursor
  
  # update iteration number by 1.
  iter_num = iter_num + 1
}

# write list of people you follow to Excel file.
write.csv(followinglist, file = "ann_is_following.csv", row.names = FALSE)




