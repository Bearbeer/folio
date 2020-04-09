class Portfolio < ActiveRecord::Base

  acts_as_paranoid

  self.table_name = :portfolios

  belongs_to :user

  # gender enum
  validates :title, length: { maximum: 500 }
  validates :name, length: { maximum: 100 }
  validates :mobile, length: { maximum: 100 }
  validates :email, length: { maximum: 500 }

  GEN = %w[남자 여자].freeze
  validates :gender, inclusion: { in: GEN }
  validates :address, length: { maximum: 1000 }
  validates :memo, length: { maximum: 5000 }

  # shareable
  def shared_link

    return false if :public_code == ''

    :public_code
  end
end