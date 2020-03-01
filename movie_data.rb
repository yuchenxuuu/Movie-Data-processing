
class Movie_Data

    attr_accessor :movie_map, :user_map, :sorted_movieList, :dataList, 
    :user_rating_map, # maps users to movies and their corresponding ratings
    :sorted_similarityMap, #user => sorted user by their similarity
    :popularityMap,
    :averageRatingMap


    def initialize(fileName)
        @fileName = fileName
        @movie_map = {} # movie map matches movie id with its frequency
        @user_map = {} # user map matches user and their rated list
        @sorted_movieList = [] # the list is a sorted movie frequency list
        @dataList = [] # data file to array form of data
        @user_rating_map = {}  
        @popularityMap = {}
        @averageRatingMap = {}
    end


    def getData
        #read the data file and puts it into an array
        file = File.open(@fileName)
        data_array = Array.new #data_array is the array of data stored by each line
        index = 0
        file.each_line{|line| #puts the data into array
            data_array[index] = line
            index += 1
        } 
       
        return data_array
    end

    def getMapping
        data_array = getData
        for i in (0..data_array.size - 1)
             movieData = data_array[i].split(" ")
             user_id = movieData[0]
             movie_id = movieData[1]
             rating = movieData[2]
             timestamp = movieData[3]
             dataList[i] = [user_id, movie_id, rating, timestamp]
            
             if !movie_map.has_key?(movie_id)
                movie_map[movie_id] = 1
             else
                movie_map[movie_id] += 1
             end

             if !user_map.has_key?(user_id)
                favor_list = []
                favor_list.push(movie_id)
                user_map[user_id] = favor_list
             else
                user_map[user_id].push(movie_id)
             end
        end
        return dataList    
    end

    def getMovie_rating_map
        # take each elements in the dataList, which are user_id map to their rated movies and ratings
        # key: user_id, value: movie => ratings
        getData
        getMapping
        for i in (0 .. dataList.size-1)
            if !user_rating_map.has_key?(dataList[i][0])
                movie_rating_map = {}
                movie_rating_map[dataList[i][1]] = dataList[i][2]
                @user_rating_map[dataList[i][0]] = movie_rating_map 
            else 
                @user_rating_map[dataList[i][0]][dataList[i][1]] = dataList[i][2]
            end
        end
        return user_rating_map
    end

    #this computes the average rating given by each user and return their 
    def getAverageRatingMap
        user_rating_map = getMovie_rating_map
        user_rating_map.each do |user, movieRatingMap|
            sumRating = 0
            count = 0
            avgRating = 0
            user_rating_map[user].each do |movie, rating|
                sumRating += rating.to_i
                count += 1
            end
            avgRating = sumRating.to_f/count
            if !averageRatingMap.has_key?(user)
                averageRatingMap[user] = avgRating
            end
        end
        return averageRatingMap
    end

    def popularity(movie_id)
        #return popularity from 1 to 5
        #divide the list by length into 5 ranges, then check which range of the movie belongs to 
       
        range = (sorted_movieList.size - 1)/5
        #level1 represents the most popular movie, 
        #level5 represents the least popular movie
        level1 = sorted_movieList[range]
        level2 = sorted_movieList[range*2]
        level3 = sorted_movieList[range*3]
        level4 = sorted_movieList[range*4]
        level5 = sorted_movieList[range*5]
     
        #movie_map[movie_id] represents the frequency of the movie
         
     
        if movie_map[movie_id] <= level4
            return 5
        elsif movie_map[movie_id] > level4 && movie_map[movie_id] <= level3
            return 4
        elsif movie_map[movie_id] > level3 && movie_map[movie_id] <= level2
            return 3
        elsif movie_map[movie_id] > level2 && movie_map[movie_id] <= level1
            return 2
        elsif movie_map[movie_id] > level1
            return 1
        end
    end

    #popularityMap is a quick look of the popularity of the movie by checking their movieid
    def getPopularityMap
        popularity_list

        movie_map.each_key do |movie|
            if !popularityMap.has_key?(movie)
                popularityMap[movie] = popularity(movie)
            end
        end
        count = 0
   
        return popularityMap
    end


    #get the average rating by given movie_id
    def getAverageRating(movie_id)
        getMovie_rating_map
        sumRating = 0
        count = 0
        dataList.each do |entry|
            if entry[1] == movie_id
                sumRating += entry[2].to_i
                count += 1

            end
        end
        avgRating = sumRating/count
        return avgRating
    end

    
    #return the sorted popularity map of the movie
    #from the most popular to least popular
    def popularity_list
        sortedmap = movie_map.sort {|a,b| b[1]<=>a[1]}.to_h
        index = 0
        sortedmap.each do |key,value|
            sorted_movieList[index] = value
            index += 1
        end
        
        return sorted_movieList
    end

    def get_topTenPopularity
        sortedmap = movie_map.sort {|a,b| b[1]<=>a[1]}.to_h
        index = 0
        top_ten_list = []
        sortedmap.each_key do |k|
            top_ten_list[index] = k
            index += 1
            if index == 10
               
                return top_ten_list
            end
        end
        return top_ten_list
    end

    def similarity(user1, user2)
        #return the similarity of the two users, which decide by the 
        user1_movieList = user_map[user1]
        user2_movieList = user_map[user2]
        similar_count = 0
        for movie1 in user1_movieList
            for movie2 in user2_movieList
                if movie1 == movie2
                    similar_count += 1
                end
            end
        end
        similarity = similar_count/((user1_movieList.size + user2_movieList.size)/2).to_f
        return similarity.round(2) 
    end

    def getSortedSimilarityList(u)
        similarity_map = {}
        sorted_similarList = []
        getMovie_rating_map
        user_map.each do |key, value|
            if u != key
                similarity_map[key] = similarity(u, key)
                
            end
        end

        sorted_similarList = similarity_map.sort_by {|a,b| b}.reverse.to_h
        return sorted_similarList
    end

    def most_similar(u)
         #return an array of top 10 users of similar taste
        top_ten_list = []
        index = 0
        sorted_similarList = getSortedSimilarityList(u)

        sorted_similarList.each_key do |key|
            top_ten_list[index] = key
            index += 1
            if index == 10
                return top_ten_list
            end
        end
        return top_ten_list
    end
end

