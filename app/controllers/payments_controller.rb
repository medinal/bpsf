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

    grant = Grant.find(params[:grant_id])
    @payment = Payment.new
    @payment.user = current_user
    @payment.grant = Grant.find(params[:grant_id])
    @payment.amount = params[:amount]
    @payment.pending!
    if @payment.save
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
