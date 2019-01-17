DryCrudJsonapiSwagger::Engine.routes.draw do
  mount Rswag::Ui::Engine => '/'
  get '/swagger.json', module: 'dry_crud_jsonapi_swagger', controller: 'apidocs', action: 'show', constraints: { format: 'json' }
end


