require './movie_data.rb'
require './Ratings.rb'



class Validator

  attr_accessor :standard_dev,
  :totalEntry, # represents how many entry exists in test dataset
  :correctPredict,# the total number of correct prediction 
  :squareDiff, # the total differenece of two ratings in square 
  :sumPredict,# the sum of all of the predicted rating 
  :sumReal # the sum of all of the real rating 

  def initialize(ratingBase, ratingTest)
  		@ratingBase = ratingBase
  	  @ratingTest = ratingTest
      # ratingBase represents a base set
      # ratingTest represents a test set

      @sumPredict = 0
      @sumReal = 0
      @squareDiff = 0 
      @totalEntry = 0 
      @correctPredict = 0
        
  end

  def validate
 
  	testList = @ratingTest.moviedata.getMapping
    @ratingBase.buildLinearRegressionModel

    testList.each do |entry|
  		#predictRating is the predicted data 
    		predictRating = @ratingBase.predict(entry[0], entry[1])
      
    		#realRating is the real data 
    		realRating = @ratingTest.checkRealRating(entry[0], entry[1]).to_i

        #check if the prediction is accurate
        if predictRating == realRating
          @correctPredict += 1
        end
    
    		@sumPredict += predictRating.to_i
    		@sumReal += realRating.to_i
    		@squareDiff += (predictRating.to_i - realRating.to_i)**2
        @totalEntry += 1
    end

  end

  def getMean 
    meanPredict = (sumPredict.to_f/totalEntry.to_f).round(2)
    meanReal = (sumReal.to_f/totalEntry.to_f).round(2)
    puts "The mean of predicted data is #{meanPredict}, and the mean of average data is #{meanReal}."

  end

  def getStandardDev
    standardDev = Math.sqrt(squareDiff.to_f/totalEntry.to_f).round(2)
    puts "The standard deviation of the prediction model is #{standardDev}"
  end

  def getAccuracy
    accuracy = (@correctPredict.to_f/totalEntry.to_f).round(2)
    puts "There are #{@correctPredict} correct prediction out of #{@totalEntry}, the accuracy of the prediction is #{accuracy}."

  end

end
