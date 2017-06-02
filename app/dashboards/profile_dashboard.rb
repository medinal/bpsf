require "administrate/base_dashboard"

class ProfileDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    id: Field::Number,
    about: Field::Text,
    address: Field::String,
    city: Field::String,
    position: Field::String,
    state: Field::Text,
    zipcode: Field::Text,
    grade: Field::String,
    home_phone: Field::String,
    work_phone: Field::String,
    subject: Field::String,
    relationship: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    started_teaching: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :id,
    :about,
    :address,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :id,
    :about,
    :address,
    :city,
    :position,
    :state,
    :zipcode,
    :grade,
    :home_phone,
    :work_phone,
    :subject,
    :relationship,
    :created_at,
    :updated_at,
    :started_teaching,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :about,
    :address,
    :city,
    :position,
    :state,
    :zipcode,
    :grade,
    :home_phone,
    :work_phone,
    :subject,
    :relationship,
    :started_teaching,
  ].freeze

  # Overwrite this method to customize how profiles are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(profile)
  #   "Profile ##{profile.id}"
  # end
end
