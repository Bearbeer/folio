# frozen_string_literal: true

module Portfolio
  # 포트폴리오 내 프로젝트 모델
  class Project < ActiveRecord::Base
    acts_as_paranoid

    self.table_name = :portfolio_projects

    default_scope { order(updated_at: :desc) }

    MAX_NAME_SIZE = 100
    MAX_DESCRIPTION_SIZE = 2000

    belongs_to :user, class_name: 'User'
    belongs_to :entity, class_name: 'Portfolio::Entity'

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
    validates :portfolio, presence: { message: '포트폴리오가 존재하지 않음' }

  end
end