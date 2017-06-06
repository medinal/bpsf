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




    # controller do
    #   # This code is evaluated within the controller class

    #   def destroy
    #     Instance method
    #     if @grant.draft? && grant_params[:status] == "pending"
    #       GrantSubmittedJob.new.async.perform(@grant)
    #     end
    #   end
    # end

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_admin_user
#   permitted
# end

end
