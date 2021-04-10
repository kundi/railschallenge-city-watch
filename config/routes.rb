Rails.application.routes.draw do
  resources :emergencies, param: :code, except: %i(new edit destroy)
  resources :responders, param: :name, except: %i(new edit destroy)
  match '*unmatched', to: 'application#route_not_found', via: :all
end
