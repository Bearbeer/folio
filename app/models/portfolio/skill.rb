# frozen_string_literal: true

module Portfolio
  # 포트폴리오 내 기술스택 모델
  class Skill < ActiveRecord::Base
    acts_as_paranoid

    self.table_name = :portfolio_skills

    belongs_to :user, class_name: 'User'
    belongs_to :portfolio, class_name: 'Portfolio::Entity'

    MAX_NAME_SIZE = 100

    validates :user, presence: { message: '회원이 존재하지 않음' }
    validates :name,
              presence: { message: '이름이 존재하지 않음' },
              length: { maximum: 100, message: '이름이 100자를 초과함'}
    validates :level,
              presence: { message: '레벨이 존재하지 않음' },
              numericality: { 
                only_integer: true,
                greater_than_or_equal_to: 1,
                less_than_or_equal_to: 5,
                message: '레벨이 1~5 범위를 벗어남'
              }
  end
end