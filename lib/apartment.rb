class Apartment <ActiveRecord::Base
  has_many :apartmentsLogins
  has many :users, through: :apartmentsLogins
end
