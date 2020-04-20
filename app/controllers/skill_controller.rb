# 스킬을 중앙 관리하는 컨트롤러
class SkillController < ApiController
  include SkillHelper

  before_action :validate_authorization

  # GET /skills
  def index
    skills = Skill.where(user: current_user)

    json(data: skills_view(skills))
  end

  # GET /skills/:id
  def show
    params.require(:id)

    skill = get_skill
    
    json(data: skill_view(skill))
  end

  # POST /skills
  def create
    require_params([:name, :level])

    skill = Skill.create(user: current_user, name: params[:name], level: params[:level])

    json(data: skill_view(skill))
  end
  
  # PUT /skills/:id
  def update
    require_params([:id, :name, :level])

    skill = get_skill
    skill.update(name: params[:name], level: params[:level])

    json(data: skill_view(skill))
  end

  # DELETE /skills/:id
  def destroy
    params.require(:id)

    skill = get_skill
    skill.destory

    json(code: 200, message: '삭제되었습니다.')
  end

  private

  # ID parameter로 skill 반환
  def get_skill
    skill = Skill.find_by(params[:id])
    raise Exceptions::NotFound unless skill
    raise Exceptions::Forbidden if skill.user != current_user

    skill
  end

  # 필수 parameter 검사
  def require_params(prop_list)
    puts prop_list
    prop_list.each do |prop|
      puts(prop)
      params.require(prop)
    end
  end
end