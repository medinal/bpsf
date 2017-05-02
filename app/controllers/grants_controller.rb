# t.text     "title"
# t.text     "summary"
# t.text     "subject_areas"
# t.text     "grade_level"
# t.text     "duration"
# t.integer  "num_classes"
# t.integer  "num_students"
# t.integer  "total_budget"
# t.text     "funds_will_pay_for"
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

  before_action :set_grant, only: [:show, :edit, :update, :destroy]


    def index
      @grants = Grant.all
    end


    def show
    end


    def new
      @grant = Grant.new
    end


    def create
      @grant = Grant.create(grant_params)
      @grant.user = current_user
      @grant.school = current_user.school
      if @grant.save
        redirect_to grant_path(@grant), notice: 'Grant was successfully created and is pending approval'
      else
        render :new
      end
    end


    def edit
    end


    def update
      if @grant.update(grant_params)
        redirect_to grant_path(@grant), notice: 'Grant was successfully updated.'
      else
        render :edit
      end
    end


    def destroy
      @grant.destroy
      redirect_to grants_path
    end


  private


    def set_grant
      @grant = Grant.find(params[:id])
    end


    def grant_params
      params.require(:grant).permit(:title, :summary, :subject_areas, :grade_level, :duration, :num_classes,
                                    :num_students, :total_budget, :funds_will_pay_for, :budget_desc, :purpose,
                                    :methods, :background, :num_collabs, :collaborators, :comments, :user_id,
                                    :state, :video, :image, :school_id, :status, :deadline)
    end

end

# t.text     "title"
# t.text     "summary"
# t.text     "subject_areas"
# t.text     "grade_level"
# t.text     "duration"
# t.integer  "num_classes"
# t.integer  "num_students"
# t.integer  "total_budget"
# t.text     "funds_will_pay_for"
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
