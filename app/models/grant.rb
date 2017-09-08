class Grant < ApplicationRecord
  belongs_to :user
  belongs_to :school
  has_many :payments, dependent: :destroy
  mount_uploader :image, ImageUploader

  enum status: { "draft" => 0, "pending" => 1, "approved" => 2, "rejected" => 3, "failed" => 4, "successful" =>5}

  def subject_areas_options
    [nil,'After School Program', 'Arts / Music', 'Arts / Dance', 'Arts / Drama',
      'Arts / Visual', 'Community Service', 'Computer / Media', 'Computer Science',
      'Foreign Language / ELL / TWI','Gardening','History & Social Studies / Multi-culturalism',
      'Mathematics','Multi-subject','Nutrition','Physical Education', 'Reading & Writing / Communication',
      'Science & Ecology','Special Ed','Student / Family Support / Mental Health']
  end

  def funds_will_pay_for_options
    [nil,'Supplies','Books','Equipment','Technology / Media',
      'Professional Guest (Consultant, Speaker, Artist, etc.)','Professional Development',
      'Field Trips / Transportation','Assembly']
  end

  validate :state_transition, on: :save
  validates :user, :school, :status, presence: true

  def progress
    "#{([self.amount_raised/self.total_budget.to_f, 1].min * 100).to_i}%"
  end

  def amount_raised
    total = 0
    self.payments.each do |payment|
      total += payment.amount
    end
    total
  end

  def percent_complete
    percent = (self.amount_raised/self.total_budget.to_f)*100
    percent = 100 if percent > 100
    percent
  end


  def days_left
    (self.deadline - Time.now.getlocal("-07:00").to_date).to_i
  end

  def past_deadline?
    days_left <= 0
  end

  def crowdfailed
    @admins = SuperUser.all
    # @admins.each do |admin|
    #   AdminCrowdfailedJob.new.async.perform(self, admin)
    # end
    GrantCrowdfailedJob.new.async.perform(self)
  end

  def check_total(total, admins, payment)
    if total < self.total_budget && total + payment.amount >= self.total_budget
      admins.each do |admin|
        AdminCrowdsuccessJob.new.async.perform(self, admin)
      end
      users_notified = []
      self.payments.all.each do |userpayment|
        if !users_notified.include?(userpayment.user)
          UserCrowdsuccessJob.new.async.perform(userpayment.user, self)
          users_notified.push(userpayment.user)
        end
      end
      GrantFundedJob.new.async.perform(self)
    elsif self.amount_raised >= (self.total_budget * 0.8) && (self.amount_raised < self.total_budget)
      DonorNearendJob.new.async.perform(self, payment.user)
    end
  end

  def display_status
    if self.status == "draft"
      return "Draft Grant"
    elsif self.status == "pending"
      return "Pending Approval"
    elsif self.status == "approved"
      return "Currently Crowdfunding"
    elsif self.status == "rejected"
      return "Rejected Grant"
    elsif self.status == "successful"
      return "Successfully Funded"
    elsif self.status == "failed"
      return "Failed To Reach Goal"
    end
  end

  def with_admin_cost
    # 9% cost added
    (total_budget * 1.09).to_i
  end

  def admin_cost
    with_admin_cost - total_budget
  end


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
