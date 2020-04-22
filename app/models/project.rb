# frozen_string_literal: true

# 프로젝트 모델
class Project < ActiveRecord::Base
  acts_as_paranoid

  self.table_name = :projects

  MAX_NAME_SIZE = 100
  MAX_DESCRIPTION_SIZE = 2000

  belongs_to :user, class_name: 'User'

  validates :user, presence: { message: '값이 존재하지 않음' }
  validates :name,
            presence: { message: '값이 존재하지 않음' },
            length: {
              maximum: MAX_NAME_SIZE,
              message: "값이 #{MAX_NAME_SIZE}자를 초과함"
            }
  validates :description,
            length: {
              maximum: MAX_DESCRIPTION_SIZE,
              message: "값이 #{MAX_DESCRIPTION_SIZE}자를 초과함"
            }
end