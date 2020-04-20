class Portfolio
  class Career < ActiveRecord::Base
    acts_as_paranoid
    
    self.table_name = :portfolio_careers

    belongs_to :user, class_name: 'User'
    belongs_to :portfolio, class_name: 'Portfolio'
    
    validates :name, presence: {message: '경력명이 존재하지 않음'}
    validate :end_date_after_start_date
    
    private
    
    def end_date_after_start_date
      return if start_date.blank? ||  end_date.blank?
      
      if end_date < start_date
        raise '날짜 설정 오류'
      end
    end 
  end
end