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

  index do
    selectable_column
    column :id
    column :title
    column :summary
    column :total_budget
    column :deadline
    column :status
    column :user_id do |grant|
      grant.user
    end
    column :school_id do |grant|
      grant.school
    end
    column :subject_areas
    column :funds_will_pay_for
    column :grade_level
    actions
  end

  show do
    h4 style: "text-align:center" do 
      link_to "View Grant", grant_path, class: "button"
    end
    attributes_table do
      row :image do |grant|
        render inline: "<%= cl_image_tag(grant.image, style: 'width:50%;')%>", locals: {grant: grant}
      end
      row :id
      row :title
      row :summary
      row :total_budget
      row :budget_desc
      row :deadline
      row :status
      row :user_id do |grant|
        grant.user
      end
      row :school_id do |grant|
        grant.school
      end
      row :duration
      row :subject_areas
      row :funds_will_pay_for
      row :grade_level
      row :num_classes
      row :num_students
      row :collaborators
      row :num_collabs
      row :purpose
      row :methods
      row :background
      row :comments
      row :video
      row :image
    end
    render partial: 'admin/payments', locals: {grant: grant}
  end

  form do |f|
    f.semantic_errors
    f.actions
    f.inputs :status, :deadline, :title, :summary, :subject_areas, :grade_level,
                  :duration, :num_classes, :num_students,
                  :total_budget, :funds_will_pay_for, :budget_desc,
                  :purpose, :methods, :background, :num_collabs,
                  :collaborators, :comments, :user_id,
                  :video, :image, :school_id          
    f.actions
  end

  controller do
    # This code is evaluated within the controller class
    def update
      @grant = Grant.find(params[:id])
      parameters = grant_params
      if params[:file]
        parameters[:image] = params[:file]
      end
      if @grant.pending? && grant_params[:status] == "approved"
        GrantCrowdfundingJob.new.async.perform(@grant)
      elsif @grant.pending? && grant_params[:status] == "rejected"
        GrantRejectedJob.new.async.perform(@grant)
      end
      if !@grant.state_transition(grant_params[:status])
        redirect_to admin_grant_path(@grant), alert: 'That is not a valid state transition'
      elsif @grant.update(parameters)
        redirect_to admin_grant_path(@grant), notice: 'Grant was successfully updated.'
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
