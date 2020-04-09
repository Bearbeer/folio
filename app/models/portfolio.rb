class Portfolio < ActiveRecord::Base
  acts_as_paranoid

  self.table_name = :portfolios

  belongs_to :user, class_name: 'User'
  has_many :skills, class_name: 'Skill'
  has_many :careers, class_name: 'Career'
  has_many :educations, class_name: 'Education'
  has_many :projects, class_name: 'Project'

  GENDER = %w(남자 여자).freeze
  MAX_SIZE = {
    title: 500,
    name: 100,
    mobile: 100,
    email: 500,
    address: 1000,
    memo: 5000
  }.freeze

  validates :user, presence: { message: '값이 존재하지 않음' }
  validates :title, presence: { message: '값이 존재하지 않음' },
            length: { maximum: MAX_SIZE[:title], message: "값이 #{MAX_SIZE[:title]}자를 초과함" }
  validates :name, length: { maximum: MAX_SIZE[:name], message: "값이 #{MAX_SIZE[:name]}자를 초과함" }
  validates :mobile, length: { maximum: MAX_SIZE[:mobile], message: "값이 #{MAX_SIZE[:mobile]}자를 초과함" }
  validates :email, length: { maximum: MAX_SIZE[:email], message: "값이 #{MAX_SIZE[:email]}자를 초과함" }
  validates :address, length: { maximum: MAX_SIZE[:address], message: "값이 #{MAX_SIZE[:address]}자를 초과함" }
  validates :memo, length: { maximum: MAX_SIZE[:memo], message: "값이 #{MAX_SIZE[:memo]}자를 초과함" }
  validates :gender, inclusion: { in: GENDER, message: '지정된 성별 분류를 따르지 않음' }, allow_nil: true

  def set_public_code
    # 이미 공유 코드가 존재하면 기존 코드 사용
    return self.public_code unless self.public_code.blank?

    begin
      code = [*('a'..'z'), *('A'..'Z'), *('0'..'9')].shuffle[0,8].join
    end while Portfolio.exists?(public_code: code)

    self.update(public_code: code)
    code
  end

end
