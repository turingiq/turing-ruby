require "spec_helper"
require './lib/turing_api'

RSpec.describe TuringAPI do
  describe "new" do
		context "input parameters have been given correctly." do
		  it "will initialize new visual api instamce with api key and mode" do 
		  	visual = TuringAPI::VisualAPI.new(ENV['API_KEY'], "sandbox")
		  	expect(visual.class).to eql(TuringAPI::VisualAPI)
		  	expect(visual.api_key).to eql(ENV['API_KEY'])
		  	expect(visual.mode).to eql('sandbox')
		  end
	  end

	  context "input parameters have been either given partially or wrongly" do
	  	it "will throw an exception for missing arguments" do
	 	  	expect { TuringAPI::VisualAPI.new }.to raise_error(ArgumentError)
	 	  	expect { TuringAPI::VisualAPI.new('', 'sandbox') }.to raise_exception('API key is not provided.')
 	    end
	  end
	end

	describe "other actions" do
		before(:all) do
			@visual = TuringAPI::VisualAPI.new(ENV['API_KEY'], 'sandbox')
		end

		it "adds a new image to index" do
			@response = @visual.create("https://images-na.ssl-images-amazon.com/images/I/71AfbkjR6AL._SX522_.jpg",1, ['men', 'shirt', 'casual-shirts'])
			expect(@response).to eq({"success"=>true})
		end

		it "deleted an image from index " do
			@image = @visual.create("https://storage.googleapis.com/turingiq/unit_test_images/backpack-1.jpg",1, ['men', 'shirt', 'casual-shirts'])
			@response = @visual.delete(1)
			expect(@response).to eq({"success"=>true})
		end

		it "crops an image automatically" do
			@response = @visual.auto_crop("https://storage.googleapis.com/turingiq/unit_test_images/backpack-1.jpg")
			expect(@response["boxes"][0]).to eq([188, 256, 656, 928])
			expect(@response["boxes"][1]).to eq([379, 343, 651, 870])
		end

		it "searches images based on given url" do
			@response = @visual.search("https://images-na.ssl-images-amazon.com/images/I/71AfbkjR6AL._SX522_.jpg")
			expect(@response["similar"]).to be_an_instance_of(Array)
		end

		it "searches similar images" do
			@response = @visual.similar(400000, ['men'])
			expect(@response["similar"][0]["similarity"].round(2).to_f).to eq(0.95)
		end

	end
end
