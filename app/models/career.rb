class Career < ActiveRecord::Base 
  acts_as_paranoid
  self.table_name = :careers
  belongs_to :user, class_name: 'User'
  validates :name, presence: {message: '경력명이 존재하지 않음'}
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? ||  end_date.blank?
    raise '날짜 설정 오류' if end_date < start_date
  end
end
