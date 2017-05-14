class Grant < ApplicationRecord
  belongs_to :user
  belongs_to :school
  has_many :payments

  enum status: { "draft" => 0, "pending" => 1, "approved" => 2, "rejected" => 3, "failed" => 4, "successful" =>5}

  enum subject_areas: ['After School Program', 'Arts / Music', 'Arts / Dance', 'Arts / Drama',
    'Arts / Visual', 'Community Service', 'Computer / Media', 'Computer Science',
    'Foreign Language / ELL / TWI','Gardening','History & Social Studies / Multi-culturalism',
    'Mathematics','Multi-subject','Nutrition','Physical Education', 'Reading & Writing / Communication','Science & Ecology',
    'Special Ed','Student / Family Support / Mental Health']

  enum funds_will_pay_for: ['Supplies','Books','Equipment','Technology / Media',
    'Professional Guest (Consultant, Speaker, Artist, etc.)','Professional Development',
    'Field Trips / Transportation','Assembly']

  validate :state_transition, on: :save
  validates :user, :school, :status, presence: true

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
      errors.add(:status, "That state transition is not possible.")
      return false
    end
  end

end
