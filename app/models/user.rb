class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  #lesson12課題で追加
  has_many :like_relationships
  has_many :likes, through: :like_relationships, source: :micropost
  has_many :reverses_of_like_relationship, class_name: 'LikeRelationships', foreign_key: 'micropost_id'
  
  #------------------
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  #lesson12課題で追加
  
  def like_set(other_user)
    unless self == other_user
      self.like_relationships.find_or_create_by(micropost_id: other_user.id)
    end
  end
  
  def like_out(other_user)
    like_relationship = self.like_relationships.find_by(micropost_id: other_user.id)
    like_relationship.destroy if like_relationship
  end

  def like?(other_user)
    self.likes.include?(other_user)
  end
  
  
  #--------------------
end



