# frozen_string_literal: true

# 포트폴리오 헬퍼
module PortfolioHelper

  def portfolios_view(portfolios)
    portfolios.map { |portfolio| portfolio_view(portfolio) }
  end

  def portfolio_view(portfolio)
    only_portfolio_view(portfolio).merge(
      careers: portfolio.careers,
      educations: portfolio.educations,
      projects: portfolio.projects,
      skills: portfolio.skills
    )
  end

  def only_portfolio_view(portfolio)
    {
      id: portfolio.id, title: portfolio.title,
      name: portfolio.name, mobile: portfolio.mobile,
      email: portfolio.email, gender: portfolio.gender,
      birthday: portfolio.birthday, address: portfolio.address,
      memo: portfolio.memo, public_code: portfolio.public_code,
      created_at: portfolio.created_at, updated_at: portfolio.updated_at
    }
  end

  # -- Portfolio Career --
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

  # -- Portfolio Education --
  def educations_view(educations)
    educations.map { |education| education_view(education) }
  end

  def education_view(education)
    {
      id: education.id, portfolio_id: education.portfolio_id,
      name: education.name, status: education.status,
      start_date: education.start_date, end_date: education.end_date,
      created_at: education.created_at, updated_at: education.updated_at
    }
  end

  # -- Portfolio Project --
  def projects_view(projects)
    projects.map { |project| project_view(project) }
  end

  def project_view(project)
    {
      id: project.id,
      portfolio_id: project.portfolio_id,
      name: project.name,
      description: project.description,
      created_at: project.created_at,
      updated_at: project.updated_at
    }
  end

  # -- Portfolio Skill --
  def skills_view(skills)
    skills.map { |skill| skill_view(skill) }
  end

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