# frozen_string_literal: true

class Portfolio
  # 프로젝트 모델
  class Project < ActiveRecord::Base
    acts_as_paranoid

    self.table_name = :portfolio_projects

    MAX_NAME_SIZE = 100
    MAX_DESCRIPTION_SIZE = 2000

    belongs_to :user, class_name: 'User'

    validates :user, presence: { message: '회원이 존재하지 않음' }
    validates :name, presence: { message: '이름이 존재하지 않음' }

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
end