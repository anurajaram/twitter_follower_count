# twitter_follower_count
<br /> R programs using Twitter API to get details of people you follow on Twitter and your followers.

<br />
<br />Program 1 - followers_id.R - Use Twitter API to collect user ids of all followers for a given Twitter handle. 
<br /> Uses concept of cursors and pagination since the Twitter API only allows 5000 ids in one call.

<br />
<br /> Program 2 - follower_details.R - Use the list of user ids (from program1 ) to generate details about those followers. 
<br /> Output image showing details of sample followers 
<br />
<br /> ![Alt text](https://github.com/anurajaram/twitter_follower_count/blob/master/Twitter_follower_details.jpg "twitter_follower_details")

<br /> Program 3 - I_follow_people.R - Program to create list of all the people you follow, along with some basic details about them (screen name, description and follower counts). 
<br /> Uses concept of cursors and pagination since the Twitter API only allows 200 usernames in one call.
<br />
