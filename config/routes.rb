Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/apidocs'
  get 'apidocs', to: 'apidocs#show', constraints: { format: 'json' }
end
