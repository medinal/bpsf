class HomeController < ApplicationController

  def index
    @grants = Grant.where(status: :approved).order(deadline: :asc)
    @grants = @grants.first(5)
  end

end
