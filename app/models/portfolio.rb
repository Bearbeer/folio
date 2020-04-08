# TABLE portfolios
# COLUMN id, user_id, title, name, mobile, email, gender, birthday, address, memo, public_code, created_at, updated_at, deleted_at
class Portfolio < ActiveRecord::Base
  acts_as_paranoid
  
  self.table_name = :portfolios

  belongs_to :user, class_name: 'User'
  has_many :skills, class_name: 'Skill'
  has_many :careers, class_name: 'Career'
  has_many :educations, class_name: 'Education'
  # has_many :projects, class_name: 'Project'

  STATUS = %w(남자 여자).freeze
  MAX_TITLE_SIZE = 500
  MAX_NAME_SIZE = 100
  MAX_MOBILE_SIZE = 100
  MAX_EMAIL_SIZE = 500
  MAX_ADDRESS_SIZE = 1000
  MAX_MEMO_SIZE = 5000

  validates :user, presence: { message: '회원이 존재하지 않음' }
  validates :title, presence: { message: '제목이 존재하지 않음' }
  validates :gender, inclusion: { in: STATUS, message: '지정된 성별 분류를 따르지 않음' }
  validates :public_code, { maximum: 10, message: '공유 링크 주소가 10글자를 초과'},
            uniqueness: { message: '중복된 공유 링크 주소'}, 
            allow_blank: true

  before_save :set_properties_below_max_size

  scope :with_info, joins(:skills, :educations, :careers) # , :projects)
  scope :recent, -> { order(created_at: :desc ) }

  class << self
    # 특정 사용자의 모든 portfolio 정보
    def get_portfolios_of_user(user_id)
      self.with_info.where(user_id: user_id).recent
    end
  end

  private

  def set_properties_below_max_size
    self.title = title.truncate(MAX_TITLE_SIZE) if title.size > MAX_TITLE_SIZE
    self.name = name.truncate(MAX_NAME_SIZE) if name.size > MAX_NAME_SIZE
    self.mobile = mobile.truncate(MAX_MOBILE_SIZE) if mobile.size > MAX_MOBILE_SIZE
    self.email = email.truncate(MAX_EMAIL_SIZE) if email.size > MAX_EMAIL_SIZE
    self.address = address.truncate(MAX_ADDRESS_SIZE) if address.size > MAX_ADDRESS_SIZE
    self.memo = memo.truncate(MAX_MEMO_SIZE) if memo.size > MAX_MEMO_SIZE
    return
  end
end
