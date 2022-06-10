Rails.application.routes.draw do
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  get "search" => "searches#search"
  
  patch "books/:id" => "books#update", as: "update_book"
  patch "users/:id" => "users#update", as: "update_user"
  
  resources :groups, except: [:destroy] do
    
  resources :homes, only: [:top, :about]
  resources :chats, only: [:show, :create]
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get :followings, on: :member
    get :followers, on: :member
    get "dairy_posts" => "users#dairy_posts"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
