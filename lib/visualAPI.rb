require 'httparty'
require 'byebug'
require 'json'

module Turing
  class VisualAPI
    attr_accessor :api_key, :api_version, :mode, :base_url, :headers
    
    def similar(id, filters=nil)
      request = @mode=="live" ? "similar" : "demo-similar"
      requested_url = @base_url+"#{request}/#{id}"
      filters = filters if !filters.nil?
      body = !filters.nil? ? '{:filter1=>"#{filters[0]}", :filter2=>"#{filters[1]}", :filter3=>"#{filters[2]}" }' : '{}'
      response = HTTParty.get(requested_url, headers: @headers, :body => body)
      response_data = response.body
      data = JSON.parse(response_data)
      data
    end

    def search(url, crop=nil)
      request = @mode=="live" ? "similar" : "demo-similar"
      requested_url = @base_url+"#{request}/search"
      crop_size = crop.join(",") if !crop.nil?
      request = HTTParty.post(requested_url, headers: @headers, :body => {:url=>"#{url}", :crop=>"#{crop_size}"})
      response_data = request.body
      data = JSON.parse(response_data)
      data
    end

    def auto_crop(url)
      requested_url = @base_url+"autocrop"
      request = HTTParty.get(requested_url, headers: @headers, :body => {:url=>"#{url}"})
      response_data = request.body
      data = JSON.parse(response_data)
      data
    end

    def create(url, id, filters=nil)
      request = @mode=="live" ? "similar" : "demo-similar"
      requested_url = @base_url+"#{request}/create"
      filters = filters if !filters.nil?
      if !filters.nil?
        request = HTTParty.post(requested_url, headers: @headers, :body => {:url=>"#{url}", :id=>"#{id}", :filter1=>"#{filters[0]}", :filter2=>"#{filters[1]}", :filter3=>"#{filters[2]}"})
      else
        request = HTTParty.post(requested_url, headers: @headers, :body => { :url=>"#{url}", :id=>"#{id}"})
      end
      response_data = request.body
      data = JSON.parse(response_data)
      data
    end

    def update(url, id)
      request = @mode=="live" ? "similar" : "demo-similar"
      requested_url = @base_url+"#{request}/create"
      url = url if !url.nil?
      request = HTTParty.post(requested_url, headers: @headers, :body => {:url=>"#{url}", :id=>"#{id}"})
      response_data = request.body
      data = JSON.parse(response_data)
      data
    end

    def delete(id)
      request = @mode=="live" ? "similar" : "demo-similar"
      requested_url = @base_url+"#{request}/#{id}"
      response = HTTParty.delete(requested_url, headers: @headers)
      response_data = response.body
      data = JSON.parse(response_data)
      data
    end


    private
    def initialize(api_key, mode="live", api_version="v1")
      self.api_key = api_key
      self.api_version = api_version
      self.mode = mode
      self.base_url = "https://api.turingiq.com/#{api_version}/"
      self.headers = { 'Authorization' => "Bearer #{api_key}" }
    end
  end
end