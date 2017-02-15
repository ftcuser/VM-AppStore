Rails.application.routes.draw do
  root 'images#index'
  resources :instances do
    member do
      get 'show'
      put 'start'
      put 'stop'
      delete 'destroy'
    end
  end

  resources :images do
    member do
      get 'launch'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
