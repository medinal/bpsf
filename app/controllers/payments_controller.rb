class PaymentsController < ApplicationController

  before_action :authenticate_user!
  before_action :has_profile?
  before_action :has_card?, only: :new
  before_action :set_payment, only: :destroy
  before_action :owner_or_admin?, only: :destroy

  def new
    @grant = Grant.find(params[:grant_id])
    @payment = Payment.new
  end

  def create
    if !current_user.stripe_token?
      Stripe.api_key = ENV["stripe_api_key"]
      customer = Stripe::Customer.create({
        description: "Customer for #{current_user.first_name} #{current_user.last_name}",
        source: params[:stripeToken]
        })
      current_user.stripe_token = customer.id
      current_user.save
    end
    #grant before adding new payment
    oldgrant = Grant.find(params[:grant_id])
    total = oldgrant.amount_raised
    @payment = Payment.new
    @payment.user = current_user
    @payment.grant = Grant.find(params[:grant_id])
    @payment.amount = params[:amount]
    @payment.pending!
    @admins = AdminUser.all
    #grant after adding new payment
    grant = Grant.find(params[:grant_id])
    #Check amount raised and send mailer if grant is funded or near funded
    if @payment.save
      UserPledgeJob.new.async.perform(@payment.user, grant, @payment)
      grant.check_total(total, @admins, @payment)
      redirect_to grant_path(@payment.grant), notice: "You have successfully pledged $#{@payment.amount}!"
    else
      render :new
    end
  end

  def destroy
    @payment.destroy
    redirect_to grants_url, notice: 'Payment was successfully destroyed.'
  end

  private

  def has_profile?
    redirect_to new_user_profiles_path + "?next=#{request.original_fullpath}", alert: "Please create a profile first." unless current_admin_user or (current_user and current_user.profile)
  end

  def payment_params
    params.permit(:amount, :grant_id, :stripeToken)
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def owner_or_admin?
    redirect_to grants_path unless @payment.user == current_user or current_admin_user
  end

  def has_card?
    if current_user and current_user.stripe_token?
      Stripe.api_key = ENV['stripe_api_key']
      customer = Stripe::Customer.retrieve(current_user.stripe_token)
      redirect_to user_path + "?current=credit-card-label", alert: 'Add a new credit card before donating' unless customer.sources.total_count > 0
    end
  end

end
