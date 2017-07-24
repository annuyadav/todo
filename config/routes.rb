Rails.application.routes.draw do
  devise_for :users

  get 'edit_profile_pic' => 'users#edit_profile_pic', as: :edit_profile_pic
  patch 'crop_profile_pic' => 'users#crop_profile_pic', as: :crop_profile_pic
  delete 'remove_profile_pic' => 'users#remove_profile_pic', as: :remove_profile_pic

  put 'update_with_password' => 'users#update_with_password', as: :update_with_password
  put 'update_without_password' => 'users#update_without_password', as: :update_without_password

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :todo_lists do
    member do
      get 'new_user'
      post 'share'
      delete 'destroy_share/:user_id' => 'todo_lists#destroy_share', as: :destroy_share
      get 'new_todo_item'
      post 'add_todo_item'
      delete 'delete_todo_item/:todo_item_id' => 'todo_lists#delete_todo_item', as: :delete_todo_item
      get 'update_todo_item/:todo_item_id' => 'todo_lists#update_todo_item', as: :update_todo_item
      get 'update_state'
      put 'sort'
    end
  end


  resources :tasks do
    put :sort, on: :collection
  end
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
