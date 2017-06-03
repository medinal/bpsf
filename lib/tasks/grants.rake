namespace :grants do
  
  desc "Check if grant deadline has been reach and update status to successful or failed"
  task update_status: :environment do
    Stripe.api_key = ENV["stripe_api_key"]
    Grant.where(status:'approved').each do |grant|
      if grant.days_left < 1
        sum = 0
        grant.payments.each do |payment|
          sum += payment.amount
        end
        if sum < grant.total_budget
          grant.status = "failed"
          grant.payments.each do |payment|
            payment.cancelled!
          end
        else
          grant.status = "successful"
          grant.payments.each do |payment|
            begin
              charge = Stripe::Charge.create(
                :customer => payment.user.stripe_token,
                :currency => 'usd',
                :amount => payment.amount*100
              )
              payment.status = "charged"
              payment.charge_id = charge.id
              payment.save

            rescue Stripe::CardError => e
              # Since it's a decline, Stripe::CardError will be caught
              puts "Card Declined for User: #{payment.user.email}"
              body = e.json_body
              err  = body[:error]
              puts "Status is: #{e.http_status}"
              puts "Type is: #{err[:type]}"
              puts "Charge ID is: #{err[:charge]}"
              # The following fields are optional
              puts "Code is: #{err[:code]}" if err[:code]
              puts "Decline code is: #{err[:decline_code]}" if err[:decline_code]
              puts "Param is: #{err[:param]}" if err[:param]
              puts "Message is: #{err[:message]}" if err[:message]

            rescue Stripe::InvalidRequestError => e
              # Invalid parameters were supplied to Stripe's API
              puts "Error handling Request"
              body = e.json_body
              p body
              err = body[:error]
              puts err[:type]
              puts "#{err[:message]} for param '#{err[:param]}'"

            rescue Stripe::StripeError => e
              body = e.json_body
              err = body[:error]
              puts err[:type]

            rescue => e
              puts e
            end
          end
        end
        grant.save
      end
    end
  end
end