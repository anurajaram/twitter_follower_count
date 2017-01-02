# author - Anupama Rajaram
# Date - Nov 24, 2016
# Description - Get Follower ids using Twitter API and cursor pagination



  
# initialidze dataframes to store follower ids
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
# we are currently getting follower ids for account = @hadleywickham
cursor = -1
api_path1 = "https://api.twitter.com/1.1/friends/list.json?cursor="
api_path2 = "&screen_name="
api_path3 = "&count=200&skip_status=true&include_user_entities=false"
iter_num = 1
username = "anu_analytics"




# using a while loop to perform pagination when return list contains >200 ids.
while ( cursor != 0 ) {
  # to indicate the program is working, print the iteration number & current cursor value  
  print(paste("current iteration =", iter_num))
  print(paste("current cursor value =", cursor))
  
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
write.csv(followinglist, file = "Ann_is_following.csv", row.names = FALSE)




