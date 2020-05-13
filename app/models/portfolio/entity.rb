# frozen_string_literal: true

module Portfolio
  # 포트폴리오 모델
  class Entity < ActiveRecord::Base
    acts_as_paranoid

    self.table_name = :portfolios

    belongs_to :user, class_name: 'User'
    has_many :skills, class_name: 'Portfolio::Skill', foreign_key: :portfolio_id, dependent: :destroy
    has_many :careers, class_name: 'Portfolio::Career', foreign_key: :portfolio_id, dependent: :destroy
    has_many :educations, class_name: 'Portfolio::Education', foreign_key: :portfolio_id, dependent: :destroy
    has_many :projects, class_name: 'Portfolio::Project', foreign_key: :portfolio_id, dependent: :destroy

    GENDER = %w[남자 여자].freeze
    MAX_SIZE = {
      title: 500,
      name: 100,
      mobile: 100,
      email: 500,
      address: 1000,
      memo: 5000
    }.freeze

    validates :user, presence: { message: '값이 존재하지 않음' }
    validates :title,
              presence: { message: '값이 존재하지 않음' },
              length: { maximum: MAX_SIZE[:title], message: "값이 #{MAX_SIZE[:title]}자를 초과함" }
    validates :name, length: { maximum: MAX_SIZE[:name], message: "값이 #{MAX_SIZE[:name]}자를 초과함" }
    validates :mobile, length: { maximum: MAX_SIZE[:mobile], message: "값이 #{MAX_SIZE[:mobile]}자를 초과함" }
    validates :email, length: { maximum: MAX_SIZE[:email], message: "값이 #{MAX_SIZE[:email]}자를 초과함" }
    validates :address, length: { maximum: MAX_SIZE[:address], message: "값이 #{MAX_SIZE[:address]}자를 초과함" }
    validates :memo, length: { maximum: MAX_SIZE[:memo], message: "값이 #{MAX_SIZE[:memo]}자를 초과함" }
    validates :gender, inclusion: { in: GENDER, message: '지정된 성별 분류를 따르지 않음' }, allow_nil: true

  end
end
