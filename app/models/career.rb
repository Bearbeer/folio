# frozen_string_literal: true

# 중앙 커리어 모델
class Career < ActiveRecord::Base
  acts_as_paranoid

  self.table_name = :careers

  MAX_NAME_SIZE = 100
  MAX_DESC_SIZE = 2000

  belongs_to :user, class_name: 'User'

  validates :name,
            presence: { message: '을 입력하세요' },
            length: {
                maximum: MAX_NAME_SIZE,
                message: "값이 #{MAX_NAME_SIZE}자를 초과함"
            }
  validates :description,
            length: {
                maximum: MAX_DESC_SIZE,
                message: "값이 #{MAX_DESC_SIZE}자를 초과함"
            }
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
