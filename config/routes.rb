Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/app_admin', as: 'rails_admin'
  resources :summaries, :only => [:create, :index, :show]
  resources :comments, :only => [:create, :destroy]
  resources :reports
  get 'select_tutor/index'
  get 'select_tutor/show/:id' => 'select_tutor#show'

  patch 'select_tutor/update'

  devise_for :tutors, controllers: {
    :registrations => 'tutors/registrations',
    :sessions => 'tutors/sessions'
  }
  devise_scope :tutor do
    get 'tutors/edit_profile' => 'tutors/registrations#edit_profile'
    put 'tutors/update_profile' => 'tutors/registrations#update_profile'
    get 'tutors/:id/photo' => 'tutors/registrations#photo'
  end
  
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }
  devise_scope :user do
    get 'users/edit_profile' => 'users/registrations#edit_profile'
    put 'users/update_profile' => 'users/registrations#update_profile'
    get 'users/:id/photo' => 'users/registrations#photo'
  end
  
  get 'home/index'
  get 'tutor_home/index'
  get 'tutor_home/user_index'
  get 'tutor_home/user_show/:id' => 'tutor_home#user_show'
  patch 'tutor_home/user_confirm'
  get 'tutor_see_summary/index'
  get 'tutor_see_summary/show/:id' => 'tutor_see_summary#show'
  root to: 'landing#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
