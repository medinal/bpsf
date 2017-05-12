class Grant < ApplicationRecord
  belongs_to :user
  belongs_to :school
  has_many :payments

  enum status: { "draft" => 0, "pending" => 1, "approved" => 2, "rejected" => 3, "failed" => 4, "successful" =>5}

  def state_transition(status)
    if      self.draft?     &&  ["pending"].include?(status)
      return true
    elsif   self.pending?   &&  ["draft", "rejected", "approved"].include?(status)
      return true
    elsif   self.approved?  &&  ["failed", "successful"].include?(status)
      return true
    elsif   self.status == status
      return true
    else
      return false
    end
  end

end
