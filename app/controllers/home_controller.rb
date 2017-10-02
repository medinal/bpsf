class HomeController < ApplicationController

  def index
    @grants = Grant.where(status: :approved).order(deadline: :asc)
    @grants = @grants.first(5)
    @school = School.all
    @grantslist = Grant.where("status = '2' OR status = '5'").paginate(page: params[:page], per_page: 5).order(deadline: :asc)
  end

end
