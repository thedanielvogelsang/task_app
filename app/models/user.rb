# frozen_string_literal: true

class User < ApplicationRecord
  enum user_role: %i[user admin superuser]
  has_one :user_authentication
  has_many :task_logs
end
