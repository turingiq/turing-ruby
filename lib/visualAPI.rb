require 'httparty'
require 'byebug'
require 'json'
require './lib/VisualAPIException'

module Turing
  class VisualAPI
    attr_accessor :api_key, :api_version, :mode, :base_url, :headers
    
    def similar(id, filters=[])
      begin
        request = @mode=="live" ? "similar" : "demo-similar"
        requested_url = @base_url+"#{request}/#{id}"
        body = !filters.empty? ? {:filter1=>"#{filters[0]['filter1']}", :filter2=>"#{filters[0]['filter2']}", :filter3=>"#{filters[0]['filter3']}" } : {}
        response = HTTParty.get(requested_url, headers: @headers, :body => body)
        response_data = response.body
        data = JSON.parse(response_data)
        data
      rescue JSON::ParserError => e 
        puts "Error message - #{e.message}"
      end
    end

    def search(url, crop=[], filters=[])
      begin
        request = @mode=="live" ? "similar" : "demo-similar"
        requested_url = @base_url+"#{request}/search"
        crop_size = !crop.empty? ? crop.join(",") : nil
        filter1 = !filters.empty? ? filters[0]['filter1'] : ""
        filter2 = !filters.empty? ? filters[0]['filter2'] : ""
        filter3 = !filters.empty? ? filters[0]['filter3'] : ""
        request = HTTParty.post(requested_url, headers: @headers, :body => {:url=>"#{url}", :crop=>"#{crop_size}", :filter1=>"#{filter1}", :filter2=>"#{filter2}", :filter3=>"#{filter3}" })
        response_data = request.body
        data = JSON.parse(response_data)
        data
      rescue JSON::ParserError => e 
        puts "Error message - #{e.message}"
      end
    end

    def auto_crop(url)
      begin
        requested_url = @base_url+"autocrop"
        request = HTTParty.get(requested_url, headers: @headers, :body => {:url=>"#{url}"})
        response_data = request.body
        data = JSON.parse(response_data)
        data  
      rescue JSON::ParserError => e 
        puts "Error message - #{e.message}"
      end
    end

    def create(url, id, filters=[], metadata=[])
      begin
        request = @mode=="live" ? "similar" : "demo-similar"
        requested_url = @base_url+"#{request}/create"
        filter1 = !filters.empty? ? filters[0]['filter1'] : " "
        filter2 = !filters.empty? ? filters[0]['filter2'] : " "
        filter3 = !filters.empty? ? filters[0]['filter3'] : " "
        title = !metadata.empty? ? metadata[0]['title'] : " "
        request = HTTParty.post(requested_url, headers: @headers, :body => {:url=>"#{url}", :id=>id, :filter1=>"#{filter1}", :filter2=>"#{filter2}", :filter3=>"#{filter3}", :title=>"#{title}" })
        response_data = request.body
        data = JSON.parse(response_data)
        data
      rescue JSON::ParserError => e 
        puts "Error message - #{e.message}"
      end
    end

    def update(url, id, filters=[], metadata=[])
      begin
        request = @mode=="live" ? "similar" : "demo-similar"
        requested_url = @base_url+"#{request}/create"
        url = url if !url.nil?
        filter1 = !filters.empty? ? filters[0]['filter1'] : " "
        filter2 = !filters.empty? ? filters[0]['filter2'] : " "
        filter3 = !filters.empty? ? filters[0]['filter3'] : " "
        title = !metadata.empty? ? metadata[0]['title'] : " "
        request = HTTParty.post(requested_url, headers: @headers, :body => {:url=>"#{url}", :id=>id, :filter1=>"#{filter1}", :filter2=>"#{filter2}", :filter3=>"#{filter3}", :title=>"#{title}" })
        response_data = request.body
        data = JSON.parse(response_data)
        data
      rescue JSON::ParserError => e 
        puts "Error message - #{e.message}"
      end
    end

    def delete(id)
      begin
        request = @mode=="live" ? "similar" : "demo-similar"
        requested_url = @base_url+"#{request}/#{id}"
        response = HTTParty.delete(requested_url, headers: @headers)
        response_data = response.body
        data = JSON.parse(response_data)
        data
      rescue JSON::ParserError => e 
        puts "Error message - #{e.message}"
      end
    end


    private
    def initialize(api_key, mode="live", api_version="v1")
      if api_key.nil? || api_key.empty?
        raise VisualAPIException.new('API key is not provided.')
      else
        self.api_key = api_key
      end

      if api_version != 'v1'
        raise VisualAPIException.new("Currenly only 'v1' is supported for api version")
      else
        self.api_version = api_version
      end
      
      if mode != 'live' && mode != 'sandbox'
        raise VisualAPIException.new("Mode can only be either 'live' or 'sandbox'. You provided: #{mode}")
      else
        self.mode = mode
      end

      self.base_url = "https://api.turingiq.com/#{api_version}/"
      self.headers = { 'Authorization' => "Bearer #{api_key}" }
    end
  end
end