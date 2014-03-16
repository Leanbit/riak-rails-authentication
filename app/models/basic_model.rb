module BasicModel
  extend ActiveSupport::Concern
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::MassAssignment
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::ForbiddenAttributesProtection

end