module Portfolio
  # 포트폴리오 하위 skill 기능 관리 컨트롤러
  class SkillController < ApiController
    before_action :validate_authorization
    
    # GET portfolios/:portfolio_id/skills
    def index
      validate_params([:portfolio_id])

      skills = Portfolio::Skill.where(
        user: current_user, 
        portfolio_id: params[:portfolio_id]
      ).order(updated_at: :desc)

      json(data: { skills: skills_view(skills) })
    end

    # POST portfolios/:portfolio_id/skills
    def create
      validate_params([:portfolio_id, :name, :level])
  
      skill = Portfolio::Skill.create!(
        user: current_user, 
        portfolio_id: params[:portfolio_id], 
        name: params[:name], 
        level: params[:level]
      )
  
      json(data: { skill: skill_view(skill) })
    end

    # PUT portfolios/:portfolio_id/skills/:id
    def update
      validate_params([:portfolio_id, :id])
  
      skill = Portfolio::Skill.find_by(
        id: params[:id], 
        portfolio_id: params[:portfolio_id], 
        user: current_user
      )
      raise Exceptions::NotFound unless skill
  
      skill.name = params[:name] if params.key?(:name)
      skill.level = params[:level] if params.key?(:level)
      skill.save!
  
      json(data: { skill: skill_view(skill) })
    end

    # DELETE portfolios/:portfolio_id/skills/:id
    def destroy
      validate_params([:portfolio_id, :id])
  
      skill = Portfolio::Skill.find_by(
        id: params[:id], 
        portfolio_id: params[:portfolio_id],
        user: current_user
      )
      raise Exceptions::NotFound unless skill
  
      skill.destroy
  
      json(code: 200, message: '삭제되었습니다.')
    end

    private

    def validate_params(props)
      props.each { |prop| params.require(prop) }
    end

    ## View Models ##

    # Skills List
    def skills_view(skills)
      skills.map { |skill| skill_view(skill) }
    end

    # Skill
    def skill_view(skill)
      {
        id: skill.id,
        portfolio_id: skill.portfolio_id,
        name: skill.name,
        level: skill.level,
        created_at: skill.created_at,
        updated_at: skill.updated_at
      }
    end
  end
end