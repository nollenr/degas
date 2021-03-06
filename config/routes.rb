Degas::Application.routes.draw do
 
  root to: 'static_pages#home'

  match '/home', to: 'static_pages#home'
  match '/help', to: 'static_pages#help'
  match '/about', to: 'static_pages#about'

  resources :sessions, only: [:new, :create, :destroy]
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  # resources :users, only: [:new, :create, :index, :edit]
  resources :users

  # match "users/new" => "users#new", :via => :get
  # match "users" => "users#create", :via => :post
  # match "users" => "users#index", :via => :get

  match "grapes" => "grape#index"
  match "grapes_list" => "grape#list"
  match "wineries_list" => "wineries#list"
  match "toc_by_grape" => "bottles#toc_by_grape"
  match "toc_by_winery" => "bottles#toc_by_winery"
  match "toc_by_location" => "bottles#toc_by_location"
  match "toc_by_bottle_type" => "bottles#toc_by_bottle_type"
  match "ratings" => "bottles#ratings"
  match "winery_ratings" => "bottles#winery_ratings"
  match "grape_ratings" => "bottles#grape_ratings"
  match "bottle_for_rating_only" => "bottles#bottle_for_rating_only"

  # resources :bottles, except: [:show, :update, :edit, :destroy] do
  # resources :bottles, except: [:show, :update, :edit, :destroy] do
  resources :bottles  do
    put :rate, on: :member
    put :buy_again, on: :member
    put :consume, on: :member
    get :copy, on: :member
    # Edit in a pop-up
    # do I need this or can I use the update function in the controller with a respond-to (the other piece of edit)
    put :change_location, on: :member
  end

  resources :wineries, except: [:destroy]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
