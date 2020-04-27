module Portfolio
  # 포트폴리오 하위 학력 기능 관리 컨트롤러
  class EducationController < ApiController
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
      validate_params([:portfolio_id, :name, :status, :start_date])
      unless params.key?(:end_date)
        raise Exceptions::BadRequest, 'end_date 파라미터가 누락되었습니다'
      end

      find_and_validate_portfolio

      education = @portfolio.educations.create!(user: current_user, 
                                                name: params[:name], 
                                                status: params[:status], 
                                                start_date: params[:start_date], 
                                                end_date: params[:end_date])
  
      json(data: { education: education_view(education) })
    end

    # PUT portfolios/:portfolio_id/educations/:id
    def update
      validate_params([:portfolio_id, :id])
      validate_unrequired_params
      
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

    def validate_unrequired_params
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

    def update_education
      @education.name = params[:name] if params.key?(:name)
      @education.status = params[:status] if params.key?(:status)
      @education.start_date = params[:start_date] if params.key?(:start_date)
      @education.end_date = params[:end_date] if params.key?(:end_date)
      @education.save!
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

    ## View Models ##

    # Educations List
    def educations_view(educations)
      educations.map { |education| education_view(education) }
    end

    # Education
    def education_view(education)
      {
        id: education.id,
        portfolio_id: education.portfolio_id,
        name: education.name,
        status: education.status,
        start_date: education.start_date,
        end_date: education.end_date,
        created_at: education.created_at,
        updated_at: education.updated_at
      }
    end
  end
end