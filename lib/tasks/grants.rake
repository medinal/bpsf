namespace :grants do
  
  desc "Check if grant deadline has been reach and update status to successful or failed"
  task update_status: :environment do
    Grant.where(status:'approved').each do |grant|
      p grant.title
      p grant.deadline.to_time.to_i - Time.now.to_i
      if grant.deadline.to_time.to_i - Time.now.to_i <= 0 
        sum = 0
        Payment.where(grant_id: grant.id).each do |payment|
          sum += payment.amount
        end
        if sum < grant.total_budget
          grant.status = "failed"
        else
          grant.status = "successful"
        end
        grant.save
      end
    end
  end
end