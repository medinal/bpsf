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
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
