class Portfolio
  class Education < ActiveRecord::Base
    acts_as_paranoid

    self.table_name = :portfolio_educations

    STATUS = %w(재학 휴학 졸업예정 졸업).freeze
    MAX_NAME_SIZE = 100

    belongs_to :user, class_name: 'User'
    belongs_to :portfolio, class_name: 'Portfolio'
    
    validates :user, presence: { message: '회원이 존재하지 않음' }
    validates :portfolio, presence: { message: '포트폴리오가 존재하지 않음' }
    validates :name, presence: { message: '학교명이 존재하지 않음' }
    validates :status, inclusion: { in: STATUS, message: '학적상태가 부적합함' }
    validates :start_date, presence: { message: '입학일자가 존재하지 않음'}

    validate :compare_dates, :validate_end_date

    before_save :set_name_below_max_size

    private

    # start_date & end_date 비교
    # end_date가 존재할 경우 start_date < end_date가 정상
    def compare_dates
      return if !end_date.present? || (start_date < end_date)

      raise '입학일자가 졸업일자보다 먼저여야 함'
    end

    # status와 end_date의 관계 확인
    # status가 '졸업'인 경우에만 end_date가 있어야 함
    def validate_end_date
      return if (status == '졸업') && end_date.present?
      return if !(status == '졸업') && !end_date.present?

      raise '학적상태가 졸업이면 졸업일자 필요, 그 외인 경우 졸업일자 불필요'
    end    
    
    # name 글자 수가 최대 크기를 넘어갈 경우 수정
    def set_name_below_max_size
      return if name.size <= MAX_NAME_SIZE

      self.name = name.truncate(MAX_NAME_SIZE)
    end

  end
end