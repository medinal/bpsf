class PaymentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :owner_or_admin?, only: [:edit, :update, :destroy]

  def index
    @payments = Payment.all
  end

  def new
    @grant = Grant.find(params[:grant_id])
    @payment = Payment.new
  end

  def edit
  end

  def create

    if !current_user.stripe_token
      Stripe.api_key = ENV["stripe_api_key"]
      customer = Stripe::Customer.create(
        :description => "Customer for #{current_user.first_name} #{current_user.last_name}",
        :source => "#{params[:stripeToken]}"
        )
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
    if @payment.save
      if total < grant.total_budget && total + @payment.amount >= grant.total_budget
        @admins.each do |admin|
          AdminCrowdsuccessJob.new.async.perform(grant, admin)
        end
      end
      redirect_to grant_path(@payment.grant), notice: "You have successfully pledged #{@payment.amount}!"
    else
      render :new
    end
  end

  def update
  end

  def destroy
    @payment.destroy
    redirect_to grants_url, notice: 'Payment was successfully destroyed.'
  end

  private



  def payment_params
    params.permit(:amount, :grant_id, :stripeToken)
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def owner_or_admin?
    redirect_to grants_path unless @payment.user == current_user or current_admin_user
  end

end
