# frozen_string_literal: true

module Portfolio
  # 포트폴리오 하위 경력 기능 관리 컨트롤러
  class CareerController < ApiController
    before_action :validate_authorization

    # GET /portfolios/:portfolio_id/careers
    def index
      params.require(:portfolio_id)
      find_and_validate_portfolio

      json(data: { careers: careers_view(@portfolio.careers) })
    end

    # POST /portfolios/:portfolio_id/careers
    def create
      params.require(:portfolio_id)
      params.require(:name)
      params.require(:start_date)
      find_and_validate_portfolio
      career = @portfolio.careers.create! attributes.merge(user: current_user)

      json(data: { career: career_view(career) })
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
      params.require(:id)
      params.require(:portfolio_id)
      find_and_validate_portfolio
      find_and_validate_career
      @career.destroy

      json(code: 200)
    end

    private

    def validate_update_params
      params.require(:id)
      params.require(:portfolio_id)
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

    def attributes
      @attributes ||= params.permit(:name, :description, :start_date, :end_date).to_h.compact
    end

    def update_career
      return if attributes.blank?

      @career.update! attributes
    end

    def careers_view(careers)
      careers.map { |career| career_view(career) }
    end

    def career_view(career)
      {
        id: career.id,
        portfolio_id: career.portfolio_id,
        name: career.name,
        description: career.description,
        start_date: career.start_date,
        end_date: career.end_date,
        created_at: career.created_at,
        updated_at: career.updated_at
      }
    end
  end
end