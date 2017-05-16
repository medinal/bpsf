class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :grant

  enum status: { "pending" => 0, "charged" => 1, "cancelled" => 2 }

end
