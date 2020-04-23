# 스킬을 중앙 관리하는 컨트롤러
class SkillController < ApiController
  before_action :validate_authorization

  # GET /skills
  def index
    skills = Skill.where(user: current_user).order(updated_at: :desc)

    json(data: { skills: skills_view(skills) })
  end

  # POST /skills
  def create
    params.require(:name)
    params.require(:level)

    skill = Skill.create!(user: current_user, name: params[:name], level: params[:level])

    json(data: { skill: skill_view(skill) })
  end
  
  # PUT /skills/:id
  def update
    params.require(:id)

    skill = Skill.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound unless skill

    skill.name = params[:name] if params.key?(:name)
    skill.level = params[:level] if params.key?(:level)
    skill.save!

    json(data: { skill: skill_view(skill) })
  end

  # DELETE /skills/:id
  def destroy
    params.require(:id)

    skill = Skill.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound unless skill

    skill.destroy

    json(code: 200, message: '삭제되었습니다.')
  end

  private

  ## View Models ##

  # Skills List
  def skills_view(skills)
    skills.map { |skill| skill_view(skill) }
  end

  # Skill
  def skill_view(skill)
    {
      id: skill.id,
      name: skill.name,
      level: skill.level,
      created_at: skill.created_at,
      updated_at: skill.updated_at
    }
  end
end