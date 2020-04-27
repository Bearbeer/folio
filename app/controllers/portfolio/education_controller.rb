module Portfolio
  # 포트폴리오 하위 학력 기능 관리 컨트롤러
  class EducationController < ApiController
    include PortfolioHelper

    before_action :validate_authorization
    
    STATUS = Education::STATUS

    # GET portfolios/:portfolio_id/educations
    def index
      validate_params([:portfolio_id])
      find_and_validate_portfolio

      json(data: { educations: educations_view(@portfolio.educations) })
    end

    # POST portfolios/:portfolio_id/educations
    def create
      validate_create_params
      find_and_validate_portfolio

      create_educations
  
      json(data: { educations: educations_view(@educations) })
    end

    # PUT portfolios/:portfolio_id/educations/:id
    def update
      validate_update_params
      find_and_validate_portfolio
      find_and_validate_education

      update_education
  
      json(data: { education: education_view(@education) })
    end

    # DELETE portfolios/:portfolio_id/educations/:id
    def destroy
      validate_params([:portfolio_id, :id])
      find_and_validate_portfolio
      find_and_validate_education
  
      @education.destroy
  
      json(code: 200, message: '삭제되었습니다.')
    end

    private

    def validate_params(props)
      props.each { |prop| params.require(prop) }
    end
    
    def validate_create_params 
      validate_params([:portfolio_id, :educations])
      
      params[:educations].each do |education_param|
        education_param.require(:name)
        education_param.require(:status)
        education_param.require(:start_date)
        unless education_param.key?(:end_date)
          raise Exceptions::BadRequest, 'end_date 파라미터가 누락되었습니다'
        end
      end
    end

    def validate_update_params
      validate_params([:portfolio_id, :id])

      if params.key?(:name) && params[:name].blank?
        raise Exceptions::BadRequest, '학교명을 비울 수 없습니다'
      end

      if params.key?(:status) && !params[:status].in?(STATUS)
        raise Exceptions::BadRequest, '부적절한 졸업구분 입니다'
      end

      if params.key?(:start_date) && params[:start_date].blank?
        raise Exceptions::BadRequest, '입학일자를 비울 수 없습니다'
      end
    end
    
    def find_and_validate_portfolio
      @portfolio = Portfolio::Entity.find_by(id: params[:portfolio_id],
                                             user: current_user)

      raise Exceptions::NotFound, '포트폴리오가 존재하지 않습니다' unless @portfolio
    end

    def find_and_validate_education
      @education = @portfolio.educations.find_by(id: params[:id])

      raise Exceptions::NotFound, '학력이 존재하지 않습니다' unless @education
    end
    
    def create_educations
      education_attrs = params[:educations].map do |education_param|
        education_param.permit(:name, :status, :start_date, :end_date).to_h.compact.merge(user: current_user)
      end

      ActiveRecord::Base.transaction do
        @educations = @portfolio.educations.create!(education_attrs)
      end
    end

    def update_education
      attributes = params.permit(:name, :status, :start_date, :end_date).to_h.compact
      return if attributes.blank?

      @education.update! attributes
    end
  end
end