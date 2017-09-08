class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :profile, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :grants, dependent: :destroy
  belongs_to :school
  validates :first_name, :last_name, :email, :role, presence: true
  before_save :format_name


  enum role: {"friends_and_family" => 0, "teacher" => 1}

  def full_name
    first_name + " " + last_name
  end

  private

  def format_name
    self.first_name = self.first_name.capitalize
    self.last_name = self.last_name.capitalize
  end
end
