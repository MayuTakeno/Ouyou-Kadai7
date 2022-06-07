class Group < ApplicationRecord
  has_one_attached :image
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  belongs_to :owner, class_name: 'User'
 
 
  validates :name, presence: true
  validates :introduction, presence: true
 
  def get_image
    (image.attached?) ? image : 'no-image.jpg'
  end
 
  def is_owned_by?(user)
    owned.id == user.id
  end
end
