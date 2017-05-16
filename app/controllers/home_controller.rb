class HomeController < ApplicationController

  def index
    @grants = Grant.where(status: :approved).order(deadline: :asc)
  end

end
