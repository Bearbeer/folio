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
  
  class << self
    # 특정 사용자의 모든 skill 정보
    def get_skills_of_user(user_id)
      self.where(user_id).order(portfolio_id: :desc).level_order
    end

    # 특정 포트폴리오의 모든 skill 정보
    def get_skills_of_portfolio(portfolio_id)
      self.where(portfolio_id).level_order
    end
  end
end
