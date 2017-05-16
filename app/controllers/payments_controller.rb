class PaymentsController < ApplicationController

  before_action :set_payment, only: [:show, :edit, :update, :destroy]

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
    @payment = Payment.new(payment_params)
    @payment.user = current_user
    @payment.grant = Grant.find(params[:grant_id])
    @payment.pending!
    if @payment.save
      redirect_to grant_path(@payment.grant), notice: 'You successfully donated!'
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
    params.require(:payment).permit(:amount, :grant_id, :status)
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

end
