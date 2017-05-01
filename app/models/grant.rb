class Grant < ApplicationRecord
  belongs_to :user
  belongs_to :school
  has_many :payments
end
