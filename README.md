# BoxViewRb

Seeing as it has been years without any support for the crocodoc gem or any of the alternative gems out their I decided to write a new wrapper for the BoxView API. The BoxView API has had some small changes, and is better documented than it used to be. You can learn more at the developer page: http://developers.box.com/view/. Not this product and API are still in beta, and likely to change in the future. BoxViewRb works with all available requests that are documented by BoxView at the time of writing.

## Installation

Add this line to your application's Gemfile:

    gem 'boxviewrb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boxviewrb

## Usage

### Configuration

All that needs to be done to use BoxView is to define your api key. To get your own API Key, visit Box.com and get a developer account. Then create a new Box View application. Scroll to the bottom of the application settings page to find your api key.

```ruby
BoxView.api_key = '#{MY_API_KEY}'

# A real world example:
BoxView.api_key = 'gyheecmm6ckk8jutlowlzfh2tbg72kck'
```

### Document

#### Create

See below for how to create a document using BoxViewRb. Not all the paramaters used are required. The url is the only parameter that will be necessary in order to make a successful call with the BoxView API. Name refers to the name of the document. Non_SVG refers to whether you want to support browsers that cannot support svg. The Height and Width parameters refer to the size of a thumbnail that will give Box an early start to generating your thumbnail for you. You must still make a second request for a thumbnail, but it will be made available sooner upon request.

After making this call the BoxView API if successful will return with a response. The response will contain a document id that you can use to make various other calls. BoxViewRb will automatically have the document id available when the response is returned. If the call to BoxView fails, a specific error will be raised depending on what went wrong.

```ruby
BoxView::Document.url 'http://seriouscatbusiness.com/pussycats.pdf'
BoxView::Document.name 'pussycats'
BoxView::Document.non_svg true
BoxView::Document.width 100
BoxView::Document.height 100
BoxView::Document.create

# Alternatively:
BoxView::Document.create
  url: 'http://seriousmonkeybusiness.com/chimpanzee.docx',
  name: 'chimpanzee',
  non_svg: true,
  width: 100,
  height: 100
```
#### MultiPart

Coming Soon...

#### List

```ruby
```

#### Show

Returns the metadata for a single document based on a specified document id.

```ruby
BoxView::Document.document_id '937778a1a54b4337a5351a78f7188a24'

# Alternatively:

```

#### Update

Update the metadata of a single document based on a specified document id. Only the name can be updated at this time.

```ruby
BoxView::Document.document_id '937778a1a54b4337a5351a78f7188a24'
BoxView::Document.name = 'recipes'
BoxView::document.update

# Alternatively:
BoxView::Document.update name: 'recipes'
```

#### Thumbnail

A request to retrieve a thumbnail representation of a document. A document id must be specified in order to make the request.

```ruby
```

#### Assets

```ruby
```

### Session

#### Create

```ruby
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/boxviewrb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request