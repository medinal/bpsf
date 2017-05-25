# t.text     "title"
# t.text     "summary"
# t.integer  "subject_areas"
# t.text     "grade_level"
# t.text     "duration"
# t.integer  "num_classes"
# t.integer  "num_students"
# t.integer  "total_budget"
# t.integer  "funds_will_pay_for"
# t.text     "budget_desc"
# t.text     "purpose"
# t.text     "methods"
# t.text     "background"
# t.integer  "num_collabs"
# t.text     "collaborators"
# t.text     "comments"
# t.integer  "user_id"
# t.string   "state"
# t.string   "video"
# t.string   "image"
# t.integer  "school_id"
# t.integer  "status"
# t.date     "deadline"
# t.datetime "created_at",         null: false
# t.datetime "updated_at",         null: false
# t.index ["school_id"], name: "index_grants_on_school_id", using: :btree
# t.index ["user_id"], name: "index_grants_on_user_id", using: :btree

# enum status: { "draft" => 0, "pending" => 1, "approved" => 2, "rejected" => 3, "failed" => 4, "successful" =>5}
#
# enum subject_areas: ['After School Program', 'Arts / Music', 'Arts / Dance', 'Arts / Drama',
#   'Arts / Visual', 'Community Service', 'Computer / Media', 'Computer Science',
#   'Foreign Language / ELL / TWI','Gardening','History & Social Studies / Multi-culturalism',
#   'Mathematics','Multi-subject','Nutrition','Physical Education', 'Reading & Writing / Communication','Science & Ecology',
#   'Special Ed','Student / Family Support / Mental Health']
#
# enum funds_will_pay_for: ['Supplies','Books','Equipment','Technology / Media',
#   'Professional Guest (Consultant, Speaker, Artist, etc.)','Professional Development',
#   'Field Trips / Transportation','Assembly']

class GrantsController < ApplicationController
  before_action :permission, except: [:index, :show]
  before_action :set_grant, only: [:show, :edit, :update, :destroy]
  before_action :owner, only: [:edit, :update, :destroy]

  # GET /grants
  def index
    if params[:filter] && params[:filter] != "all" && ['approved', 'failed', 'successful'].include?(params[:filter])
      @grants = Grant.where(status: params[:filter]).paginate(page: params[:page], per_page: 5).order(deadline: :asc)
      @filter = params[:filter]
    else
      @grants = Grant.where(status: [:approved, :failed, :successful]).paginate(page: params[:page], per_page: 5).order(deadline: :asc)
    end
  end

  # GET user/grants
  def usergrants
    if params[:filter] && params[:filter] != "all" && ['draft', 'pending', 'rejected', 'approved', 'failed', 'successful'].include?(params[:filter])
      @grants = current_user.grants.where(status: params[:filter]).paginate(page: params[:page], per_page: 5).order(deadline: :asc)
      @filter = params[:filter]
    else
      @grants = current_user.grants.where(status: [:draft, :pending, :rejected, :approved, :failed, :successful]).paginate(page: params[:page], per_page: 5).order(deadline: :asc)
    end
  end

  # GET /grants/1
  def show
  end

  # GET /grants/new
  def new
    @grant = Grant.new
  end

  # GET /grants/1/edit
  def edit
  end

  # POST /grants
  def create
    parameters = grant_params
    if params[:file]
      parameters[:image] = params[:file]
    end
    

    @grant = Grant.new(parameters)
    @grant.user = current_user
    @grant.school = School.find(current_user.school_id)
    if @grant.save
      redirect_to @grant, notice: 'Grant was successfully created.'
    else
      render :new
    end
    if grant_params[:status] == "pending" 
      GrantSubmittedJob.new.async.perform(Grant.last)
    end
  end

  # PATCH/PUT /grants/1
  def update
    parameters = grant_params
    if params[:file]

      parameters[:image] = params[:file]
    end
    if @grant.draft? && grant_params[:status] == "pending"
      GrantSubmittedJob.new.async.perform(@grant)
    end
    if !@grant.state_transition(grant_params[:status])
      render :edit, notice: 'That is not a valid state transition'
    elsif @grant.update(parameters)
      redirect_to @grant, notice: 'Grant was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /grants/1
  def destroy
    @grant.destroy
    redirect_to grants_url, notice: 'Grant was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grant
      if !Grant.exists?(params[:id])
        redirect_to grants_path
      else
        @grant = Grant.find(params[:id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def grant_params
      params.require(:grant).permit(:title, :summary, :subject_areas, :grade_level,
                                    :duration, :num_classes, :num_students,
                                    :total_budget, :funds_will_pay_for, :budget_desc,
                                    :purpose, :methods, :background, :num_collabs,
                                    :collaborators, :comments, :user_id, :state,
                                    :video, :image, :school_id, :status, :deadline)
    end


    def permission
      redirect_to grants_path unless current_user and ((current_user.teacher? and current_user.approved?) or current_user.admin?)
    end

    def owner
      redirect_to grant_path(@grant) unless (@grant.user == current_user || current_user.admin?)
    end

end
