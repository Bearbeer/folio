class Skill < ActiveRecord::Base
  acts_as_paranoid
  
  self.table_name = :portfolio_skills

  belongs_to :portfolio
  belongs_to :user

  # portfolio_id, user_id는 Association을 통해 검증
  validates :name, presence: { message: '이름이 존재하지 않음' },
            length: { 
              maximum: 100,
              message: '이름이 100글자를 초과'
            }
            
  validates :level, presence: { message: '레벨이 존재하지 않음' },
            numericality: { 
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 5,
              message: '레벨이 1~5 범위를 벗어남'
            }

  scope :level_order, -> { order(level: :desc ) }
end
