class Project < ApplicationRecord
  belongs_to :customer
  has_many :tasks
end
