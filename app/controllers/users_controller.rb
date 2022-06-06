class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]


  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @users_all = User.where.not(id: current_user.id)
    @book = Book.new
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    @book = @user
    @books = Book.all
    @users = User.all
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def followings
    user = User.find(params[:id])
    @users = user.followings
    @users_all = User.where.not(id: current_user.id)
    @book = Book.new
    @user = current_user
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
    @users_all = User.where.not(id: current_user.id)
    @book = Book.new
    @user = current_user
  end
  
  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      created_at = params[:created_at]
      @search_book = @books.where(['created_at FAVORITE ? ', "#{create_at}%"]).count
    end
  end

    private

    def user_params
        params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end

end
