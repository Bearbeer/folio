class Skill < ActiveRecord::Base
  acts_as_paranoid
  
  self.table_name = :skills

  belongs_to :user, class_name: 'User'

  MAX_NAME_SIZE = 100

  validates :user, presence: { message: '회원이 존재하지 않음' }
  validates :name, presence: { message: '이름이 존재하지 않음' }
  validates :level, presence: { message: '레벨이 존재하지 않음' },
            numericality: { 
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 5,
              message: '레벨이 1~5 범위를 벗어남'
            }
            
  before_save :set_name_below_max_size

  scope :level_order, -> { order(level: :desc ) }

  private

  def set_name_below_max_size
    return if name.size <= MAX_NAME_SIZE
    self.name = name.truncate(MAX_NAME_SIZE)
  end
end