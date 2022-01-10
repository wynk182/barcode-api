Encoded::Engine.routes.draw do
  resources :api, only: [:create] do
    get :download, on: :collection
  end
end