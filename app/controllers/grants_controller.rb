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

class GrantsController < ApplicationController
  before_action :permission, except: [:index, :show]
  before_action :set_grant, only: [:show, :edit, :update, :destroy]

  # GET /grants
  def index
    @grants = Grant.all
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
    @grant = Grant.new(grant_params)
    @grant.user = current_user
    @grant.school = School.find(current_user.school_id)
    if @grant.save
      redirect_to @grant, notice: 'Grant was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /grants/1
  def update
    if !@grant.state_transition(grant_params[:status])
      render :edit, notice: 'That is not a valid state transition'
    end
    if @grant.update(grant_params)
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
      @grant = Grant.find(params[:id])
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

end
