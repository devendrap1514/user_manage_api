class User < ApplicationRecord
  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A[\w.]+@[a-zA-Z]+\.com\z/ }
  validates :password, presence: true
end
