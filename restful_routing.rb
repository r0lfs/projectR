                  Prefix Verb   URI Pattern                      Controller#Action
        new_user_session GET    /users/sign_in(.:format)         users/sessions#new
            user_session POST   /users/sign_in(.:format)         users/sessions#create
    destroy_user_session DELETE /users/sign_out(.:format)        users/sessions#destroy
       new_user_password GET    /users/password/new(.:format)    devise/passwords#new
      edit_user_password GET    /users/password/edit(.:format)   devise/passwords#edit
           user_password PATCH  /users/password(.:format)        devise/passwords#update
                         PUT    /users/password(.:format)        devise/passwords#update
                         POST   /users/password(.:format)        devise/passwords#create
cancel_user_registration GET    /users/cancel(.:format)          users/registrations#cancel
   new_user_registration GET    /users/sign_up(.:format)         users/registrations#new
  edit_user_registration GET    /users/edit(.:format)            users/registrations#edit
       user_registration PATCH  /users(.:format)                 users/registrations#update
                         PUT    /users(.:format)                 users/registrations#update
                         DELETE /users(.:format)                 users/registrations#destroy
                         POST   /users(.:format)                 users/registrations#create
          check_username POST   /check_username(.:format)        users/registrations#check_username
             check_email POST   /check_email(.:format)           users/registrations#check_email
            user_ratings GET    /user_ratings(.:format)          user_ratings#index
                         POST   /user_ratings(.:format)          user_ratings#create
         new_user_rating GET    /user_ratings/new(.:format)      user_ratings#new
        edit_user_rating GET    /user_ratings/:id/edit(.:format) user_ratings#edit
             user_rating GET    /user_ratings/:id(.:format)      user_ratings#show
                         PATCH  /user_ratings/:id(.:format)      user_ratings#update
                         PUT    /user_ratings/:id(.:format)      user_ratings#update
                         DELETE /user_ratings/:id(.:format)      user_ratings#destroy
                    root GET    /                                home#index
