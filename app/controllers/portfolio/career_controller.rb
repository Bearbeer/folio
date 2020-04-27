# frozen_string_literal: true

module Portfolio
  # 포트폴리오 하위 경력 기능 관리 컨트롤러
  class CareerController < ApiController
    include PortfolioHelper

    before_action :validate_authorization

    # GET /portfolios/:portfolio_id/careers
    def index
      validate_params([:portfolio_id])
      find_and_validate_portfolio

      json(data: { careers: careers_view(@portfolio.careers) })
    end

    # POST /portfolios/:portfolio_id/careers
    def create
      validate_create_params
      find_and_validate_portfolio

      create_careers

      json(data: { careers: careers_view(@careers) })
    end

    # PUT /portfolios/:portfolio_id/careers/:id
    def update
      validate_update_params
      find_and_validate_portfolio
      find_and_validate_career

      update_career

      json(data: { career: career_view(@career) })
    end

    # DELETE /portfolios/:portfolio_id/careers/:id
    def destroy
      validate_params([:portfolio_id, :id])
      find_and_validate_portfolio
      find_and_validate_career

      @career.destroy

      json(code: 200, message: '삭제되었습니다.')
    end

    private

    def validate_params(props)
      props.each { |prop| params.require(prop) }
    end
    
    def validate_create_params 
      validate_params([:portfolio_id, :careers])
      
      params[:careers].each do |career_param|
        career_param.require(:name)
        career_param.require(:start_date)
      end
    end

    def validate_update_params
      validate_params([:portfolio_id, :id])
      validate_name
      validate_start_date
    end

    def validate_name
      return unless params.key?(:name) && params[:name].blank?

      raise Exceptions::BadRequest, '프로젝트 명을 지울 수는 없습니다'
    end

    def validate_start_date
      return unless params.key?(:start_date) && params[:start_date].blank?

      raise Exceptions::BadRequest, '경력 시작일시를 지울 수는 없습니다'
    end

    def find_and_validate_portfolio
      @portfolio = Portfolio::Entity.find_by id: params[:portfolio_id],
                                             user: current_user

      raise Exceptions::NotFound, '포트폴리오가 존재하지 않습니다' unless @portfolio
    end

    def find_and_validate_career
      @career = @portfolio.careers.find_by(id: params[:id])

      raise Exceptions::NotFound, '경력이 존재하지 않습니다' unless @career
    end

    def create_careers
      career_attrs = params[:careers].map do |career_param|
        career_param.permit(:name, :description, :start_date, :end_date).to_h.compact.merge(user: current_user)
      end

      ActiveRecord::Base.transaction do
        @careers = @portfolio.careers.create!(career_attrs)
      end
    end

    def update_career
      attributes = params.permit(:name, :description, :start_date, :end_date).to_h.compact
      return if attributes.blank?

      @career.update! attributes
    end
  end
end