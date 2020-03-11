
# Movie Data
Movie Data is an analyzing tool that for provided to generate results based on the input datasets

## Data sets information
The data set, ml-100k, consists of 100,000 ratings of 1682 movies from 943 users and can be downloaded from one of these places:

[grouplen](http://www.grouplens.org)

[brandeis](http://dennett.cs-i.brandeis.edu/talks/ml-100k.zip)

The Data sets has each row of 4 items:
user_id
movie_id
rating
timestamp

## Installation

```ruby
 gem install ruby_linear_regression

 ```

##

## Introduction

movie_data class
```ruby


MovieData#popularity(movie_id) 
#returns an integer from 1 to 5 to indicate the popularity of a certain movie.

MovieData#get_topTenPopularity
#return the top 10 movies that has been frequently rated

MovieData#popularity_list
# this will generate a list of all movie_id’s ordered by decreasing popularity

MovieData#similarity(user1, user2)
#generates a number between 0 and 1 indicating the similarity in movie preferences between user1 and user2. 0 is no similarity.

MovieData#most_similar(u)
#this return a list of users whose tastes are most similar to the tastes of user u

```

Ratings class

```ruby

Ratings#buildLinearRegressionModel
#for each user, build a linear regression model with their rating data(y_data) and the popularity 
# x_data

Ratings#predict(user, movie)
#return the predicted rating of the given user and movie_id
```

Validator class

```ruby
Validator#validate
# take two data sets, base set ans test set, and use two ratings instance to 

Validator#getMean
# print out the mean of the predicted rating and the mean of real rating

Validator#getStandardDev
#print the standard deviation of the predicted rating data and the real rating data 

Validator#getAccuracy
#print out the accuracy of the prediction

```
## Algorithm explained
Prediction algorithm(linear regression): The prediction of the possible rating is depend on the popularity of the movie.(The lookup for movie's popularity is O(1) becuase I stored it in the map). I used a linear regression ruby package to do the calculation. I build a map for every user that maps the user_id with their specific linear regression model. 

-advantage: It has a time complexity of O(n) since all the predict method is to use the user_id to find the regression model. Thus the prediction method only takes O(1) runtime, and scanning through the entries of test datasets takes O(n).

-drawback: Only considered one feature, for some data there are no enough value to get the prediction result, which will affect the accuracy of the prediction.Also, because it needs several maps, the space complexity is O(n).

## Analysis 
Time complexity: O(n)
Space complexity: O(n)
The running script of the program:

Start the prediction: 2020-01-28 11:41:40 -0500
The mean of predicted data is 3.55, and the mean of average data is 3.54.
The standard deviation of the prediction model is 1.07
There are 7471 correct prediction out of 20000, the accuracy of the prediction is 0.37.
The mean of predicted data is 3.55, and the mean of average data is 3.54.
The standard deviation of the prediction model is 1.06
There are 7551 correct prediction out of 20000, the accuracy of the prediction is 0.38.
The mean of predicted data is 3.53, and the mean of average data is 3.52.
The standard deviation of the prediction model is 1.05
There are 7610 correct prediction out of 20000, the accuracy of the prediction is 0.38.
The mean of predicted data is 3.54, and the mean of average data is 3.52.
The standard deviation of the prediction model is 1.05
There are 7495 correct prediction out of 20000, the accuracy of the prediction is 0.37.
The mean of predicted data is 3.54, and the mean of average data is 3.52.
The standard deviation of the prediction model is 1.05
There are 7490 correct prediction out of 20000, the accuracy of the prediction is 0.37.
Finished the prediction: 2020-01-28 11:41:48 -0500

The prediction is about 37% - 38%,
##Benchmarking
It takes 8 secs to finish 5 predictions, so the time spent on each prediction is about 1.6 secs
Since the running time is O(n), the growth of the running time is in linear curve. If we increase the datasets by 10 times, the running time will be 10n, which is 80 seconds. 


##Reflection
The most enjoying part of this PA is to think out of a model that can predict the large input data in a controlable time. I struggled with the algorithm a lot as well, after making several trials that has a large running time, I started thinking of using hashmap to store the data. 
Two things I learned from this programming assignment: The first thing I get more familiar with ruby programming than previous assignment. The other thing is that I learned how to use space in order to trade off for time. The first algorithm I designed(which is predictTwo in the Ratings class) is to predict the rating by finding the average rating of the other similar users, while the algorthm needs O(n^2 logn) run time since it needs to sort the similar users list every time.  




