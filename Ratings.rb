require './movie_data.rb'
require 'matrix'
require 'ruby_linear_regression'

#t = Movie_Data.new('ml-100k/u.data')
class Ratings
    attr_accessor :moviedata, #instance of Moovie_data class
    :user_rating_map, # maps users to movies and their corresponding ratings
    :user_predictMap,# maps users with their prediction model
    :popularityMap # maps the movie id with their popularity 
    :avgRatingMap# maps the user_if with their average rating 

    def initialize(filename)
        @moviedata = Movie_Data.new(filename)
        @user_rating_map = moviedata.getMovie_rating_map
        @user_predictMap = {}
        @popularityMap = moviedata.getPopularityMap
        @avgRatingMap = moviedata.getAverageRatingMap
       
    end

    # Our user's poredicted rating is based on other users average rating of the movie  
    # and the popularity of the movie

    def buildLinearRegressionModel
      
        user_rating_map.each_key do |user|
            count = 0
             x_data = []
             y_data = []
            user_rating_map[user].each do |movie, rating|
                rating = user_rating_map[user][movie].to_i
                popularity = @popularityMap[movie].to_i
                
               
                x_data.push([popularity])
                y_data.push(rating)
            end
            #create regression model
            linear_regression = RubyLinearRegression.new
            #load training data
            linear_regression.load_training_data(x_data, y_data)
            # Train the model using the normal equation
            linear_regression.train_normal_equation
            
            if !@user_predictMap.has_key?(user)
                @user_predictMap[user] = linear_regression 
            end
           
        end

    end

    #The predicted data is based on movie's average rating*k1
    # and the movie's popularity*2
    #The prediction is based on the average of these two results 
    def predict(user, movie)

       popularity = @popularityMap[movie].to_i
    
       feature = [popularity]
       linearRegressionModel = user_predictMap[user]
       
        predictRating = linearRegressionModel.predict(feature)

        #if there is no enough data to make the predict, then we will take the average rating
        # of the given user
        if predictRating.nan?
            return @avgRatingMap[user].to_i
        end
        if predictRating >= 1 && predictRating<= 5
            if predictRating*10%10 >= 5
                return predictRating.ceil
            else 
                return predictRating.floor
            end
        else 
            if predictRating > 5
                return 5
            else
                return 1
            end
        end
    end

    # predictTwo is designed for smaller datasets, which may takes longer runing time than predictone
    # by finding possible ratings based on taste of similar users 
    # To predicts the user rating, we first find the user with their similarity in their taste
    # and try to find how they rate the movie
    # def predictTwo(user, movie)
    #     #First, we have to find the user list sorted by vsimilairty
    #     #Then we try to find the ratings that given by their most similar users
    #     sorted_similarityMap = moviedata.getSortedSimilarityMap
    #     sorted_similarity_list = moviedata.getSortedSimilarityList(user)
    #     rating_table = []
    #     index = 0
    #     #record the rating of other users based on target users similarity list
    #     sorted_similarity_list.each_key do |key|
    #         similar_user =  user_rating_map[key]
    #         if similar_user.has_key?(movie)
    #             rating_table[index] = similar_user[movie].to_i
    #             index += 1
    #         end
    #     end
    #     sumRating = 0
    #     #count the rating of the first 10 similar user's rating of target movie
    #     if rating_table.size > 5
    #         for i in (0 .. 4)
    #             sumRating += rating_table[i]
    #         end
    #     else
    #         for i in (0 .. rating_table.size-1)
    #             sumRating += rating_table[i]
    #         end
    #     end
    #     #count the average rating of the top 10 most similar users's rating
    #     avgRating = sumRating/5.to_f
    #     #round the final result to nearest integer
    #     if avgRating*10%10 >= 5
    #         return avgRating.ceil
    #     else 
    #         return avgRating.floor
    #     end
    # end

    #checks the real rating of the user
    def checkRealRating(user, movie)
        
        if user_rating_map.has_key?(user)
            if  user_rating_map[user].has_key?(movie)
                return user_rating_map[user][movie]
            else
                puts "The user hasn't rate this movie yet."
            end
        else
            puts "The user id doesn't exist in the list."
        end
    end

end



