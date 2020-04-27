# frozen_string_literal: true

module Portfolio
  # 포트폴리오 하위 skill 기능 관리 컨트롤러
  class SkillController < ApiController
    include PortfolioHelper

    before_action :validate_authorization
    
    # GET portfolios/:portfolio_id/skills
    def index
      validate_params([:portfolio_id])
      find_and_validate_portfolio

      json(data: { skills: skills_view(@portfolio.skills) })
    end

    # POST portfolios/:portfolio_id/skills
    def create
      validate_create_params
      find_and_validate_portfolio

      create_skills
  
      json(data: { skills: skills_view(@skills) })
    end

    # PUT portfolios/:portfolio_id/skills/:id
    def update
      validate_params([:portfolio_id, :id])
      find_and_validate_portfolio
      find_and_validate_skill

      update_skill
  
      json(data: { skill: skill_view(@skill) })
    end

    # DELETE portfolios/:portfolio_id/skills/:id
    def destroy
      validate_params([:portfolio_id, :id])
      find_and_validate_portfolio
      find_and_validate_skill
  
      @skill.destroy
  
      json(code: 200, message: '삭제되었습니다.')
    end

    private

    def validate_params(props)
      props.each { |prop| params.require(prop) }
    end

    def validate_create_params 
      validate_params([:portfolio_id, :skills])
      
      params[:skills].each do |skill_param|
        skill_param.require(:name)
        skill_param.require(:level)
      end
    end

    def find_and_validate_portfolio
      @portfolio = Portfolio::Entity.find_by(id: params[:portfolio_id],
                                             user: current_user)
      
      raise Exceptions::NotFound, '포트폴리오가 존재하지 않습니다' unless @portfolio
    end
    
    def find_and_validate_skill
      @skill = @portfolio.skills.find_by(id: params[:id])

      raise Exceptions::NotFound, '기술 스택이 존재하지 않습니다' unless @skill
    end
    
    def create_skills
      skill_attrs = params[:skills].map do |skill_param|
        skill_param.permit(:name, :level).to_h.merge(user: current_user)
      end

      ActiveRecord::Base.transaction do
        @skills = @portfolio.skills.create!(skill_attrs)
      end
    end

    def update_skill
      attributes = params.permit(:name, :level).to_h.compact
      puts attributes
      return if attributes.blank?

      @skill.update! attributes
    end
  end
end