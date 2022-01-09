Encoded::Engine.routes.draw do
  resources :api, only: [:create]
end