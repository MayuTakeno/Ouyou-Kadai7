class Book < ApplicationRecord

  has_one_attached :image
  belongs_to :user  
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :week_favorites, ->  { where(created_at: ((Time.current.at_end_of_day 
                                - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) 
                                }, class_name: 'Favorite'
  has_many :view_counts, dependent: :destroy
  
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_day_ago, -> (n) { where(created_at: n.day.ago.all_day) }
  #scope :created_2days, -> { where(created_at: 2.days.ago.all_day) } 
  #scope :created_3days, -> { where(created_at: 3.days.ago.all_day) } 
  #scope :created_4days, -> { where(created_at: 4.days.ago.all_day) }
  #scope :created_5days, -> { where(created_at: 5.days.ago.all_day) }
  #scope :created_6days, -> { where(created_at: 6.days.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
  
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