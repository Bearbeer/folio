class Education < ActiveRecord::Base
  # deleted_at 기반 소프트 딜리트 기능 이용
  acts_as_paranoid

  self.table_name = :portfolio_educations

  belongs_to :user
  belongs_to :portfolio

  STATUS = {
    in_school: '재학',
    graduated: '졸업',
    candidate: '졸업예정',
    absence: '휴학'    
  }.freeze

  validates :status, inclusion: { in: STATUS, message: '학적상태가 존재하지 않음' }
  validates :name, presence: { message: '학교명이 존재하지 않음' }
  validates :start_date, presence: { message: '시작일자가 존재하지 않음' }

  validate :validate_end_date, :validate_date

  private

  # status와 end_date 관계 확인
  def validate_end_date
    return unless (status == graduated) ^ end_date.present?

    raise '종료일자 정책 위반'
  end

  # start_date < end_date 확인
  def validate_date
    return if (start_date < end_date) || !end_date.present?

    raise '시작일자, 종료일자 재설정'
  end

end