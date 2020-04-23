# 스킬을 중앙 관리하는 컨트롤러
class SkillController < ApiController
  include SkillHelper

  before_action :validate_authorization

  # GET /skills
  def index
    skills = Skill.where(user: current_user).order(updated_at: :desc)

    json(data: { skills: skills_view(skills) })
  end

  # GET /skills/:id
  def show
    params.require(:id)

    json(data: { skill: skill_view(skill) })
  end

  # POST /skills
  def create
    require_params([:name, :level])

    skill = Skill.create!(user: current_user, name: params[:name], level: params[:level])

    json(data: { skill: skill_view(skill) })
  end
  
  # PUT /skills/:id
  def update
    require_params([:id, :name, :level])

    skill.update!(name: params[:name], level: params[:level])

    json(data: { skill: skill_view(skill) })
  end

  # DELETE /skills/:id
  def destroy
    params.require(:id)

    skill.destroy

    json(code: 200, message: '삭제되었습니다.')
  end

  private

  # ID parameter로 skill 반환
  def skill
    return @skill if @skill

    @skill = Skill.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound unless @skill

    @skill
  end

  # 필수 parameter 검사
  def require_params(prop_list)
    prop_list.each do |prop|
      params.require(prop)
    end
  end
end