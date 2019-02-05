# DryCrudJsonapiSwagger
This Gem provides a Rails Engine to generate the api documentation for Applications based on [`dry_crud_jsonapi`].
The documentation is exposed as a swagger v2 specification and can be viewed with the included, interactive swagger web interface.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'dry_crud_jsonapi_swagger'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install dry_crud_jsonapi_swagger
```

## Usage
* Implement the `json:api` in your application with [`dry_crud_jsonapi`]
* Mount the engine in your `routes.rb`:

      mount DryCrudJsonapiSwagger::Engine => '/apidocs'
      
The swagger webinterface is available on the mount path, i.e. `/apidocs`.
To get the swagger v2 specification, just add `/swagger.json` to the mount path, i.e. `/apidocs/swagger.json`.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


[`dry_crud_jsonapi`]: https://github.com/puzzle/dry_crud_jsonapi