class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :profile
  validates :first_name, :last_name, :email, :role, presence: true


  enum role: {"friends_and_family" => 0, "teacher" => 1, "admin" => 2}
end
