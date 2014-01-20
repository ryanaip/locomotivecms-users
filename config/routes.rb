Rails.application.routes.draw do
  Locomotive::ContentType.refresh_devise_mappings!

  page_constraints = ->(r) do
    Locomotive::ContentType.user_type_names(r.subdomain).include? r.params[:user_type]
  end

  constraints(page_constraints) do
    get    "/:user_type/sign_in(.:format)",  to: "locomotive/users/sessions#new", as: 'new_content_type_session'
    post   "/:user_type/sign_in(.:format)",  to: "locomotive/users/sessions#create", as: 'content_type_session'
    get    "/:user_type/sign_out(.:format)",  to: "locomotive/users/sessions#destroy"
    post   "/:user_type/password(.:format)",  to: "locomotive/users/passwords#create", as: 'content_type_password'
    get    "/:user_type/password/new(.:format)",  to: "locomotive/users/passwords#new", as: 'new_content_type_password'
    get    "/:user_type/password/edit(.:format)",  to: "locomotive/users/passwords#edit"
    put    "/:user_type/password(.:format)",  to: "locomotive/users/passwords#update"
    get    "/:user_type/cancel(.:format)",  to: "locomotive/users/registrations#cancel"
    post   "/:user_type(.:format)",  to: "locomotive/users/registrations#create", as: 'content_type_registration'
    get    "/:user_type/sign_up(.:format)",  to: "locomotive/users/registrations#new", as: 'new_content_type_registration'
    get    "/:user_type/edit(.:format)",  to: "locomotive/users/registrations#edit"
    put    "/:user_type(.:format)",  to: "locomotive/users/registrations#update"
    delete "/:user_type(.:format)",  to: "locomotive/users/registrations#destroy"
    post   "/:user_type/confirmation(.:format)",  to: "locomotive/users/confirmations#create", as: 'content_type_confirmation'
    get    "/:user_type/confirmation/new(.:format)",  to: "locomotive/users/confirmations#new", as: 'new_content_type_confirmation'
    get    "/:user_type/confirmation(.:format)",  to: "locomotive/users/confirmations#show"
  end
end
