Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'articles', to: 'articles#get'
  get 'articles/search', to: 'articles#search'
  get 'articles/related', to: 'articles#related'
end
