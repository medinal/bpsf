require "administrate/base_dashboard"

class GrantDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    school: Field::BelongsTo,
    payments: Field::HasMany,
    id: Field::Number,
    title: Field::Text,
    summary: Field::Text,
    grade_level: Field::Text,
    duration: Field::Text,
    num_classes: Field::Number,
    num_students: Field::Number,
    total_budget: Field::Number,
    budget_desc: Field::Text,
    purpose: Field::Text,
    methods: Field::Text,
    background: Field::Text,
    num_collabs: Field::Number,
    collaborators: Field::Text,
    comments: Field::Text,
    state: Field::String,
    video: Field::String,
    image: Field::String,
    status: Field::String.with_options(searchable: false),
    deadline: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    subject_areas: Field::String.with_options(searchable: false),
    funds_will_pay_for: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :title,
    :user,
    :school,
    :payments,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :school,
    :payments,
    :id,
    :title,
    :summary,
    :grade_level,
    :duration,
    :num_classes,
    :num_students,
    :total_budget,
    :budget_desc,
    :purpose,
    :methods,
    :background,
    :num_collabs,
    :collaborators,
    :comments,
    :state,
    :video,
    :image,
    :status,
    :deadline,
    :created_at,
    :updated_at,
    :subject_areas,
    :funds_will_pay_for,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :school,
    :payments,
    :title,
    :summary,
    :grade_level,
    :duration,
    :num_classes,
    :num_students,
    :total_budget,
    :budget_desc,
    :purpose,
    :methods,
    :background,
    :num_collabs,
    :collaborators,
    :comments,
    :state,
    :video,
    :image,
    :status,
    :deadline,
    :subject_areas,
    :funds_will_pay_for,
  ].freeze

  # Overwrite this method to customize how grants are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(grant)
  #   "Grant ##{grant.id}"
  # end
end
