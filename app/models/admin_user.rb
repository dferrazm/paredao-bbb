class AdminUser < ActiveRecord::Base
  devise :database_authenticatable
end
