class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Translation
  extend ActiveModel::Naming
  
  attr_accessor :name, :email, :password, :password_confirmation

end