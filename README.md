# TuringAPI

Turing visual search and visually similar recommendations API library for RUBY. The REST API documentation can be found here: [https://api.turingiq.com/doc/](https://api.turingiq.com/doc/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'turing_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install turing_api



## Usage

Initialize
--------

```ruby
#You can initialize the `VisualAPI` class with below parameters.

api_key = 'your_api_key' # You can get API key when you login at: https://www.turingiq.com/login
mode = 'live'            # the mode can be either `live` or `sandbox`. Default mode is `live`.
@visual = TuringAPI::VisualAPI.new('api_key', 'mode')
```

This library uses namespacing. When instantiating the object, you need to either use the fully qualified namespace:

```ruby
@visual = TuringAPI::VisualAPI.new('your_api_key')
```

Or alias it:

```ruby
require './lib/VisualAPI'

@visual = TuringAPI::VisualAPI.new(ENV['your_api_key'])
```

Autocrop
--------

Detect objects in image and get bounding boxes around objects detected.

```ruby
# image_url is required field.
image_url = "https://example.com/image_url.jpg"

# now let's call the API.
resp = @visual.auto_crop(image_url)
```

The bounding boxes returned by this method can be given to visual search to improve visual search quality.


Insert
------

You need to insert images to our index to query on them. The insert function can be written as below.

```ruby
# id is required field.
id = 'image_id'

# image_url is required field.
image_url = "https://example.com/image_url.jpg"

# Filters argument is optional. You can specify upto 3 filters as per example given below.
# Filters can be useful when querying images from our index. You can apply any filter
# as per your requirement.
filters = ["filter1" => "onefilter", "filter2" => "twofilter", "filter3" => "threefilter"]

# Metadata is optional. You can pass additional information about your image which will be
# returned when you query image from our index.
metadata = ["title" => "Image Title"]

# now let's call the API.
resp = @visual.create(id, image_url, filters, metadata)
```

Update
------

If you need to update information to indexed image, you can use update function. If you call update function for id which is not already indexed, it will insert the image to index.

```ruby
# id is required field. Provide id for which you need to update the information.
id = 'image_id'

# image_url is optional field. You can pass `null` if you would like to keep URL unchanged.
image_url = "https://example.com/image_url.jpg"

# Filters argument is optional. You can specify upto 3 filters as per example given below.
# Filters can be useful when querying images from our index. You can apply any filter
# as per your requirement. The filters you provide here will be overwritten.
filters = ["filter1" => "onefilter", "filter2" => "twofilter", "filter3" => "threefilter"]

# Metadata is optional. You can pass additional information about your image which will be
# returned when you query image from our index. Existing metadata values will be overwritten
# based on keys supplied to this array.
metadata = ["title" => "Image Title"]

# now let's call the API.
resp = @visual.update(id, image_url, filters, metadata)
```

Delete
------

You can delete image from index with this method.

```ruby
# id is required field.
id = 'image_id'

# now let's call the API.
resp = @visual.delete(id)
```

Visual Search
-------------

Visual search can be used to search indexed images based on query image.

```ruby
# image_url is required field. The API will perform visual search on the image and return
image_url = "https://example.com/image_url.jpg"

# crop_box is optional field. You can supply empty array if you don't want to specify crop box.
# The format of crop box is [xmin, ymin, xmax, ymax]
crop_box = [188, 256, 656, 928]

# Filters argument is optional. You can specify upto 3 filters.
# For example, if you specify filter1 = "nike", it will only return images which are indexed with
# "nike" as filter1.
filters = ["filter1" => "nike"]

# now let's call the API.
resp = @visual.search(image_url, crop_box, filters)
```

Visual Recommendations
----------------------

Visual recommendations give visually similar image recommendations which can be used to display recommendation widget on e-commerce sites which greatly improved CTR and conversion rates.

```ruby
# image_url is required field. The API will perform visual search on the image and return
id = "some_product_id"

# Filters argument is optional. You can specify upto 3 filters.
# For example, if you specify filter1 = "nike", it will only return images which are indexed with
# "nike" as filter1.
filters = ["filter1" => "nike"]

# now let's call the API.
resp = @visual.similar(id, filters)
```

Run Tests
----------------------

```sh
API_KEY='api_key' rspec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/turingiq/turing-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TuringAPI project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/turingiq/turing-ruby/blob/master/CODE_OF_CONDUCT.md).
