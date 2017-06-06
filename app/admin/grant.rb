ActiveAdmin.register Grant do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :summary, :subject_areas, :grade_level,
              :duration, :num_classes, :num_students,
              :total_budget, :funds_will_pay_for, :budget_desc,
              :purpose, :methods, :background, :num_collabs,
              :collaborators, :comments, :user_id, :state,
              :video, :image, :school_id, :status, :deadline

              

      controller do
        # This code is evaluated within the controller class

          def update
            @grant = Grant.find(params[:id])
            parameters = grant_params
            if params[:file]
              parameters[:image] = params[:file]
            end
            if @grant.draft? && grant_params[:status] == "pending"
              GrantSubmittedJob.new.async.perform(@grant)
              p "heloo"
            end
            if @grant.approved? && grant_params[:status] == "failed"
              AdminCrowdfailedJob.new.async.perform(@grant, @grant.user)
            end
            if !@grant.state_transition(grant_params[:status])
              render :edit, notice: 'That is not a valid state transition'
            elsif @grant.update(parameters)
              if grant_params[:status] == "draft"
              redirect_to @grant, notice: 'Grant was successfully updated.'
              elsif grant_params[:status] == "pending"
              redirect_to @grant, notice: 'Grant was successfully submitted.'
              end
            else
              render :edit
            end
          end

          def grant_params
            params.require(:grant).permit(:title, :summary, :subject_areas, :grade_level,
                                          :duration, :num_classes, :num_students,
                                          :total_budget, :funds_will_pay_for, :budget_desc,
                                          :purpose, :methods, :background, :num_collabs,
                                          :collaborators, :comments, :user_id, :state,
                                          :video, :image, :school_id, :status, :deadline)
          end
          
      end



#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_admin_user
#   permitted
# end

end
