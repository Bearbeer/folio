# frozen_string_literal: true

# 포트폴리오 조회/생성/수정/삭제 기능을 관리하는 컨트롤러
class PortfolioController < ApiController
  include PortfolioHelper

  before_action :validate_authorization

  # GET /portfolios
  def index
    portfolios = Portfolio::Entity.where(user: current_user).order(updated_at: :desc)

    json(data: { portfolios: portfolios_view(portfolios)})
  end

  # GET /portfolios/:id
  def show
    params.require(:id)
    portfolio = Portfolio::Entity.find_by(user: current_user, id: params[:id])
    raise Exceptions::NotFound, '포트폴리오가 존재하지 않습니다' unless portfolio

    json(data: { portfolio: portfolio_view(portfolio)})
  end

  # POST /portfolios
  def create
    params.require(:title)
    portfolio = Portfolio::Entity.create! attributes.merge(user: current_user)

    json(data: { portfolio: portfolio_view(portfolio)})
  end

  # PUT /portfolios/:id
  def update
    validate_update_params
    find_and_validate_portfolio
    update_portfolio

    json(data: { portfolio: only_portfolio_view(@portfolio)})
  end

  # DELETE /portfolios/:id
  def destroy
    params.require(:id)
    find_and_validate_portfolio

    @portfolio.destroy

    json(code: 200)
  end

  # POST /portfolio/:id/share
  def share
    find_and_validate_portfolio
    code = @portfolio.share

    json(data: { code: code })
  end

  private

  def validate_update_params
    params.require(:id)
    return unless params.key?(:title) && params[:title].blank?

    raise Exceptions::BadRequest, '포트폴리오 제목을 비울 수 없습니다'
  end

  def find_and_validate_portfolio
    @portfolio = Portfolio::Entity.find_by(id: params[:id], user: current_user)

    raise Exceptions::NotFound, '포트폴리오가 존재하지 않습니다' unless @portfolio
  end

  def update_portfolio
    return if attributes.blank?

    @portfolio.update! attributes
  end

  def attributes
    @attributes ||= params.permit(:title, :name, :mobile, :email, :gender, :birthday, :address, :memo).to_h.compact
  end
end