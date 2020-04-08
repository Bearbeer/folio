class Education < ActiveRecord::Base
  acts_as_paranoid

  self.table_name = :portfolio_educations

  STATUS = %w(재학 휴학 졸업예정 졸업).freeze
  MAX_NAME_SIZE = 100

  belongs_to :user, class_name: 'User'
  # belongs_to :portfolio, class_name: 'Portfolio'

  validates :user, presence: { message: '회원이 존재하지 않음' }
  # validates :portfolio, presence: { message: '포트폴리오가 존재하지 않음' }
  validates :status, inclusion: { in: STATUS, message: '상태가 올바르지 않음' }

  before_save :set_name_below_max_size

  def set_name_below_max_size
    return if name.size <= MAX_NAME_SIZE

    self.name = name.truncate(MAX_NAME_SIZE)
  end
end