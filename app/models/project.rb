class Project < ActiveRecord::Base
  acts_as_paranoid

  self.table_name = :portfolio_projects

  MAX_NAME_SIZE = 100
  MAX_DESCRIPTION_SIZE = 2000

  belongs_to :user, class_name: 'User'
  belongs_to :portfolio, class_name: 'Portfolio'

  validates :user, presence: { message: '회원이 존재하지 않음' }
  validates :name, presence: { message: '이름이 존재하지 않음' }
  validates :portfolio, presence: { message: '포트폴리오가 존재하지 않음' }

  before_save :set_name_below_max_size, :set_desc_below_max_size

  private

  def set_name_below_max_size
    return if name.size <= MAX_NAME_SIZE

    self.name = name.truncate(MAX_NAME_SIZE)
  end

  def set_desc_below_max_size
    return if description.size <= MAX_DESCRIPTION_SIZE

    self.description = description.truncate(MAX_DESCRIPTION_SIZE)
  end
end