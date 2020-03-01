require './Ratings.rb'
require './Validator.rb'
require './movie_data.rb'


class Control
  def initialize
  
  end

  def run
  	basedata1 = Ratings.new('ml-100k/u1.base')
	testdata1 = Ratings.new('ml-100k/u1.test')
	basedata2 = Ratings.new('ml-100k/u2.base')
	testdata2 = Ratings.new('ml-100k/u2.test')
	basedata3 = Ratings.new('ml-100k/u3.base')
	testdata3 = Ratings.new('ml-100k/u3.test')
	basedata4 = Ratings.new('ml-100k/u4.base')
	testdata4 = Ratings.new('ml-100k/u4.test')
	basedata5 = Ratings.new('ml-100k/u5.base')
	testdata5 = Ratings.new('ml-100k/u5.test')
  	validator1 = Validator.new(basedata1,testdata1)
  	validator1.validate
  	validator1.getMean
  	validator1.getStandardDev
  	validator1.getAccuracy
	validator2 = Validator.new(basedata2,testdata2)
	validator2.validate
  	validator2.getMean
  	validator2.getStandardDev
  	validator2.getAccuracy
	validator3 = Validator.new(basedata3,testdata3)
	validator3.validate
  	validator3.getMean
  	validator3.getStandardDev
  	validator3.getAccuracy
	validator4 = Validator.new(basedata4,testdata4)
	validator4.validate
  	validator4.getMean
  	validator4.getStandardDev
  	validator4.getAccuracy
	validator5 = Validator.new(basedata5,testdata5)
	validator5.validate
  	validator5.getMean
  	validator5.getStandardDev
  	validator5.getAccuracy
  end
end

control = Control.new
puts "Start the prediction: #{Time.now}"
control.run
puts "Finished the prediction: #{Time.now}"