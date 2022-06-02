Rails.application.routes.draw do
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  get "search" => "searches#search"
  get "chat/:id", to: "chats#show", as: "chat"

  patch "books/:id" => "books#update", as: "update_book"
  patch "users/:id" => "users#update", as: "update_user"

  resources :homes, only: [:top, :about]
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
  resources :chats, only: [:create]
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get :followings, on: :member
    get :followers, on: :member
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
