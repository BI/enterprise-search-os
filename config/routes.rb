EnterpriseSearch::Application.routes.draw do

  # the constraints ensure that the segment is one of the searched_index
  # if none is present then it uses the default (see also application_controller.rb before_action)
  scope '(:searched_index)', :constraints => {:searched_index => /(an_index|another_index)/} do

    root :to => 'searches#search_facets', :via => [:get, :post]

    match '/advanced_search' => 'searches#search_facets',
          :via               => [:get, :post],
          :defaults          => {:advanced_search_flag => 'advanced'},
          :as                => 'advanced_search'

    post '/query_feedback'     => 'searches#query_feedback',       :as => 'query_feedback'

    post '/export_results_csv' => 'export_results#csv',  :as => 'export_results_csv'

    get 'suggest/:field' => 'query_builder#suggest', :as => 'suggest'

  end


  scope ':searched_index', :constraints => { :searched_index => /(website)/ } do
    get 'content_search' => 'content_searches#search', :as => 'content_search'
  end

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
