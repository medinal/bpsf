ActiveAdmin.register Profile do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :about, :address, :city, :state,
                :zipcode, :grade, :home_phone, :work_phone,
                :started_teaching, :user_id

  index do
    selectable_column
    column :user_id do |profile|
      link_to profile.user.full_name, admin_user_path(profile.user)
    end
    column :role do |profile|
      profile.user.role
    end
    column :about
    column :address
    column :city
    column :state
    column :zipcode
    column :grade
    column :home_phone
    column :work_phone
    column :started_teaching
    actions
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
