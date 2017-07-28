ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_admin_user
#   permitted
# end
  permit_params :email, :first_name, :last_name, :stripe_token, :school_id, :role, :teacher, :password, :password_confirmation

  index do
    selectable_column
    column :id
    column :first_name
    column :last_name
    column :email
    column :role
    column :stripe_token
    column :school_id do |user|
      user.school
    end
    column :profile_id do |user|
      user.profile
    end
    actions
  end

  form do |f|
    f.inputs "New User"do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role
      f.input :school
    end
    f.actions
  end

end
