# Skill 헬퍼
module SkillHelper
  def skills_view(skills)
    skills.map { |skill| skill_view(skill) }
  end

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