# frozen_string_literal: true

# 학력 모델
class Education < ActiveRecord::Base
  acts_as_paranoid

  self.table_name = :educations

  STATUS = %w[재학 휴학 졸업예정 졸업].freeze
  MAX_NAME_SIZE = 100

  belongs_to :user, class_name: 'User'

  validates :name,
            presence: { message: '학교명이 존재하지 않음' },
            length: {
              maximum: MAX_NAME_SIZE,
              message: "값이 #{MAX_NAME_SIZE}자를 초과함"
            }
  validates :status, inclusion: { in: STATUS, message: '학적상태가 부적합함' }
  validates :start_date, presence: { message: '입학일자가 존재하지 않음' }
  validate :validate_end_date

  private

  # 종료일자가 시작일자보다 먼저이면 예외처리한다
  # 종료일자가 없고 학적상태가 '졸업'이면 예외처리한다
  def validate_end_date
    if end_date.present?
      return if start_date <= end_date

      errors.add :end_date, '종료일자가 시작일자 이후이어야 합니다'
    else
      return if status != '졸업'

      errors.add :end_date, '졸업일자를 지정하세요'
    end
  end

end