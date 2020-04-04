class Portfolio < ActiveRecord::Basea
    act_as_paranoid

    self.table_name = :portfolios

    belongs_to :user
		
		#gender enum 
		enum GENDER:  {male: '남자', female: '여자'}
		validates :gender, :inclusion => {in: GENDER.keys}
    #공유 가능상태
    def shared_link
			return false if public_code == ''
			return self.public_code


		end


end