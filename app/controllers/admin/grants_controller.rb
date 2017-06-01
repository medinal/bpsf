module Admin
  class GrantsController < Admin::ApplicationController
    before_action :set_grant, only: [:show, :edit, :update, :destroy]

   helper_method :current_user

    

    # PATCH/PUT /grants/1
    def update
      parameters = grant_params
      if params[:file]

        parameters[:image] = params[:file]
      end
      if @grant.draft? && grant_params[:status] == "pending"
        GrantSubmittedJob.new.async.perform(@grant)
      end
      if @grant.approved? && grant_params[:status] == "failed"
        AdminCrowdfailedJob.new.async.perform(@grant, @grant.user)
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

      

  end
end