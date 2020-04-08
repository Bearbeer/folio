class Portfolio < ActiveRecord::Base
  acts_as_paranoid

  self.table_name = :portfolios

  MAX_TITLE_SIZE = 500
  MAX_NAME_SIZE = 100
  MAX_MOBILE_SIZE = 100
  MAX_EMAIL_SIZE = 500
  MAX_ADDRESS_SIZE = 1000
  MAX_MEMO_SIZE = 5000

  GENDER = %w(남자 여자).freeze

  belongs_to :user, class_name: "User"
  has_many :career, class_name: "Career"
  has_many :education, class_name: "Education"
  has_many :project, class_name: "Project"
  has_many :skill, class_name: "Skill"

  before_validation :set_public_code_if_nil

  validates :user, presence: { message: '회원이 존재하지 않음' }
  validates :title, presence: { message: '제목이 존재하지 않음' }
  validates :name, presence: { message: '성명이 존재하지 않음' }
  validates :gender, inclusion: { in: GENDER, message: '성별이 부적합함' }
  validates :public_code, format: {
                            :with => /\A[a-zA-Z0-9]{8}\z/,
                            message: '공유 코드 정책 위반'
                          }

  validate :validate_birthday

  before_save :set_title_below_max_size, :set_name_below_max_size, 
              :set_mobile_below_max_size, :set_email_below_max_size, 
              :set_address_below_max_size, :set_memo_below_max_size

  private
  
  # public_code 발급을 안 한 경우 임시로 지정
  # 문제가 될 수 있음..
  def set_public_code_if_nil
    return if public_code.present?

    self.public_code = '00000000'
  end

  # birthday는 과거여야 함
  def validate_birthday
    return if !birthday.present? || (birthday <= Time.now)

    raise '생년월일이 부적합함'
  end

  # 각 column의 글자 수가 최대 크기를 넘어갈 경우 수정
  def set_title_below_max_size
    return if title.size <= MAX_TITLE_SIZE

    self.title = title.truncate(MAX_TITLE_SIZE)
  end

  def set_name_below_max_size
    return if name.size <= MAX_NAME_SIZE

    self.name = name.truncate(MAX_NAME_SIZE)
  end

  def set_mobile_below_max_size
    return if mobile.size <= MAX_MOBILE_SIZE

    self.mobile = mobile.truncate(MAX_MOBILE_SIZE)
  end

  def set_email_below_max_size
    return if email.size <= MAX_EMAIL_SIZE

    self.email = email.truncate(MAX_EMAIL_SIZE)
  end

  def set_address_below_max_size
    return if address.size <= MAX_ADDRESS_SIZE

    self.address = address.truncate(MAX_ADDRESS_SIZE)
  end

  def set_memo_below_max_size
    return if memo.size <= MAX_MEMO_SIZE

    self.memo = memo.truncate(MAX_MEMO_SIZE)
  end        
end
