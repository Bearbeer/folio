# frozen_string_literal: true

module Portfolio
  # 포트폴리오 하위 프로젝트 기능 관리 컨트롤러
  class ProjectController < ApiController
    include PortfolioHelper

    before_action :validate_authorization

    # GET /portfolios/:portfolio_id/projects
    def index
      params.require(:portfolio_id)
      find_and_validate_portfolio

      json(data: { projects: projects_view(@portfolio.projects) })
    end

    # POST /portfolios/:portfolio_id/projects
    def create
      params.require(:portfolio_id)
      params.require(:name)
      find_and_validate_portfolio
      project = @portfolio.projects.create! attributes.merge(user: current_user)

      json(data: { project: project_view(project) })
    end

    # PUT /portfolios/:portfolio_id/projects/:id
    def update
      validate_update_params
      find_and_validate_portfolio
      find_and_validate_project
      update_project

      json(data: { project: project_view(@project) })
    end

    # DELETE /portfolios/:portfolio_id/projects/:id
    def destroy
      params.require(:id)
      params.require(:portfolio_id)
      find_and_validate_portfolio
      find_and_validate_project
      @project.destroy

      json(code: 200)
    end

    private

    def validate_update_params
      params.require(:id)
      params.require(:portfolio_id)
      return unless params.key?(:name) && params[:name].blank?

      raise Exceptions::BadRequest, '프로젝트 명을 지울 수는 없습니다'
    end

    def find_and_validate_portfolio
      @portfolio = Portfolio::Entity.find_by id: params[:portfolio_id],
                                             user: current_user

      raise Exceptions::NotFound, '포트폴리오가 존재하지 않습니다' unless @portfolio
    end

    def find_and_validate_project
      @project = @portfolio.projects.find_by(id: params[:id])

      raise Exceptions::NotFound, '프로젝트가 존재하지 않습니다' unless @project
    end

    def attributes
      @attributes ||= params.permit(:name, :description).to_h.compact
    end

    def update_project
      return if attributes.blank?

      @project.update! attributes
    end
  end
end