class Book < ApplicationRecord

  has_one_attached :image
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :week_favorites, ->  { where(created_at: ((Time.current.at_end_of_day 
                                - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) 
                                }, class_name: 'Favorite'
  has_many :view_counts, dependent: :destroy
  
  validates :title, presence:true
  validates :body, presence:true, length:{ maximum: 200 }

  #検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forword_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backword_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end

  def get_image
    if image.attached?
      image
    else
      'no_image.jpg'
    end
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end