class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @profile = current_user.profile
    @payments = current_user.payments
    @school = current_user.school
    Stripe.api_key = ENV['stripe_api_key']
    @customer = Stripe::Customer.retrieve(@user.stripe_token)

    # c.sources.create({source: 'src_1AV5kjJn01ZneUxaQyai5zf2'})
  end

  def create_card
    Stripe.api_key = ENV['stripe_api_key']
    begin
      tok = Stripe::Token.retrieve(params[:card_token])
      customer = Stripe::Customer.retrieve(current_user.stripe_token)
      customer.sources.create({source: tok})
      redirect_to current_user, notice: 'Successfully created card'
    rescue => e
      redirect_to current_user, notice: 'Could not find token to create card'
    end 
  end

  def edit_card
    Stripe.api_key = ENV['stripe_api_key']
    customer = Stripe::Customer.retrieve(current_user.stripe_token)
    card_found = false
    customer.sources.each do |card|
      if card.id.include?(params[:card_id])
        card_found = true
        card_params.keys.each do |key|
          unless card_params[key].empty?
            card[key] = card_params[key]
          end
        end
        begin
          card.save
          if params[:default]
            customer.default_source = card.id
            customer.save
          end
          redirect_to current_user, notice: 'Successfully updated card'
        rescue => e
          p e
          redirect_to current_user, notice: 'Could not update card'
        end
        break
      end
    end
    redirect_to current_user, notice: 'Could not find card' unless card_found
  end

  def delete_card
    Stripe.api_key = ENV['stripe_api_key']
    customer = Stripe::Customer.retrieve(current_user.stripe_token)
    card_found = false
    customer.sources.each do |card|
      if card.id.include?(params[:card_id])
        card_found = true
        begin
          card.delete
          redirect_to current_user, notice: 'Successfully deleted card'
        rescue => e
          p e
          redirect_to current_user, notice: 'Could not delete card'
        end
      end
    end
    redirect_to current_user, notice: 'Could not find card' unless card_found
  end

  private

  def card_params
    params.permit(:name, :exp_month, :exp_year, :address_city, :address_state, :address_zip, :address_line1, :address_line2, :address_country)
  end
end
