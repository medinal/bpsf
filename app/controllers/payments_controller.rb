class PaymentsController < ApplicationController

  before_action :authenticate_user!
  before_action :has_profile?
  before_action :stripe_token_and_no_card?, only: :new
  before_action :set_payment, only: :destroy
  before_action :owner_or_admin?, only: :destroy
  before_action :set_next

  def new
    @grant = Grant.find(params[:grant_id])
    @payment = Payment.new
    update_profile?
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
    unless current_admin_user or (current_user and current_user.profile)
      session[:next] = "#{request.original_fullpath}"
      redirect_to new_user_profiles_path, alert: "Please create a profile first."
    end
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

  def stripe_token_and_no_card?
    if current_user and current_user.stripe_token?
      Stripe.api_key = ENV['stripe_api_key']
      customer = Stripe::Customer.retrieve(current_user.stripe_token)
      unless customer.sources.total_count > 0
        session[:next] = "#{request.original_fullpath}"
        redirect_to user_path + "?current=credit-card-label", alert: 'Add a new credit card before donating'
      end
    end
  end

  def update_profile?
    # Update profile if you are coming from clicking the donate button on grant show page
    if request.base_url + grant_path(@grant) == request.referer
      flash[:info] = "Please confirm the information below before donating."
      session[:next] = "#{request.original_fullpath}"
      redirect_to edit_user_profiles_path
    end
  end

  def set_next
    @next = session[:next] if session[:next]
    session[:next] = nil
  end

end
