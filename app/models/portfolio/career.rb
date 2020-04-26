# frozen_string_literal: true

module Portfolio
  # 포트폴리오 내의 커리어 모델
  class Career < ActiveRecord::Base
    acts_as_paranoid

    self.table_name = :portfolio_careers

    default_scope { order(updated_at: :desc) }

    belongs_to :user, class_name: 'User'
    belongs_to :portfolio, class_name: 'Portfolio::Entity'

    validates :name, presence: { message: '을 입력하세요' }
    validates :start_date, presence: { message: '을 지정하세요' }
    validate :validate_end_date

    private

    # 종료일자가 시작일자 이후인지 확인한다
    def validate_end_date
      return if end_date.blank?
      return if start_date <= end_date

      errors.add :end_date, '종료일자는 시작일자 이후이어야 합니다'
    end
  end
end