Rails.application.routes.draw do
  resources :events do
    collection do
      get :fetch_weather  # Ruta para obtener el clima
      get :new_without_worker
    end
  end
  
  resources :workers do
    resources :events, only: [:index], controller: 'worker_events' 
  end
  
  root 'events#index'
end


