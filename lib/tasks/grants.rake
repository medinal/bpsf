namespace :grants do
  
  desc "Check if grant deadline has been reach and update status to successful or failed"
  task update_status: :environment do
    Grant.where(status:'approved').each do |grant|
      if grant.days_left < 1
        sum = 0
        grant.payments.each do |payment|
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