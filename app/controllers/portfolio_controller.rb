# frozen_string_literal: true

# 포트폴리오 조회/생성/수정/삭제 기능을 관리하는 컨트롤러
class PortfolioController < ApiController
  before_action :validate_authorization

  # GET /portfolios
  def index
    portfolios = Portfolio::Entity.where(user: current_user).order(updated_at: :desc)

    json(data: { portfolios: portfolios_view(portfolios)})
  end
  
  # POST /portfolios
  def create
    params.require(:title)
    raise Exceptions::BadRequest, 'name 파라미터가 누락되었습니다' unless params.key?(:name)
    raise Exceptions::BadRequest, 'mobile 파라미터가 누락되었습니다' unless params.key?(:mobile)
    raise Exceptions::BadRequest, 'email 파라미터가 누락되었습니다' unless params.key?(:email)
    raise Exceptions::BadRequest, 'gender 파라미터가 누락되었습니다' unless params.key?(:gender)
    raise Exceptions::BadRequest, 'birthday 파라미터가 누락되었습니다' unless params.key?(:birthday)
    raise Exceptions::BadRequest, 'address 파라미터가 누락되었습니다' unless params.key?(:address)
    raise Exceptions::BadRequest, 'memo 파라미터가 누락되었습니다' unless params.key?(:memo)
    params.require(:portfolio_skills).require(:name)
    params.require(:portfolio_skills).require(:level)
    params.require(:portfolio_educations).require(:name)
    params.require(:portfolio_educations).require(:status)
    params.require(:portfolio_educations).require(:start_date)
    params.require(:portfolio_educations).require(:end_date)
    params.require(:portfolio_projects).require(:name)
    params.require(:portfolio_projects).require(:description)
    params.require(:portfolio_careers).require(:name)
    params.require(:portfolio_careers).require(:description)
    params.require(:portfolio_careers).require(:start_date)
    params.require(:portfolio_careers).require(:end_date)

    portfolio = Portfolio::Entity.create!(user: current_user, title: params[:title], name: params[:name],
                                  mobile: params[:mobile], email: params[:email], gender: params[:gender], 
                                  birthday: params[:birthday], address: params[:address], memo: params[:memo] )
    
    params[:portfolio_skills].each do |portfolio_skill|
      Portfolio::Skill.create!(user: current_user, portfolio: portfolio, name: portfolio_skill[:name], level: portfolio_skill[:level].to_i)
    end

    params[:portfolio_educations].each do |portfolio_education|
      Portfolio::Education.create!(user: current_user, portfolio: portfolio, name: portfolio_education[:name],
                                   status: portfolio_education[:status], start_date: portfolio_education[:start_date],
                                   end_date: portfolio_education[:end_date])
    end

    params[:portfolio_projects].each do |portfolio_project|
      Portfolio::Project.create!(user: current_user, portfolio: portfolio, name: portfolio_project[:name],
                                 description: portfolio_project[:description])
    end

    params[:portfolio_careers].each do |portfolio_career|
      Portfolio::Career.create!(user: current_user, portfolio: portfolio, name: portfolio_career[:name],
                                description: portfolio_career[:description], start_date: portfolio_career[:start_date],
                                end_date: portfolio_career[:end_date])
    end

    json(data: { portfolio: portfolio_view(portfolio)})
  end

  # PUT /portfolios/:id
  def update
    params.require(:id)

    if params.key?(:title) && params[:title].blank?
        raise Exceptions::BadRequest, '포트폴리오 제목을 비울 수 없습니다'
    end

    portfolio = Portfolio::Entity.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound, '포트폴리오가 존재하지 않습니다' unless portfolio

    portfolio.title = params[:title] if params.key?(:title)
    portfolio.name = params[:name] if params.key?(:name)
    portfolio.mobile = params[:mobile] if params.key?(:mobile)
    portfolio.email = params[:email] if params.key?(:email)
    portfolio.gender = params[:gender] if params.key?(:gender)
    portfolio.birthday = params[:birthday] if params.key?(:birthday)
    portfolio.address = params[:address] if params.key?(:address)
    portfolio.memo = params[:memo] if params.key?(:memo)
    portfolio.save!

    json(data: { portfolio: only_portfolio_view(portfolio)})
  end

  # DELETE /portfolios/:id
  def destroy
    params.require(:id)

    portfolio = Portfolio::Entity.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound, '포트폴리오가 존재하지 않습니다' unless portfolio

    portfolio.destroy

    json(code: 200)
  end

  private

  def portfolios_view(portfolios)
    portfolios.map { |portfolio| portfolio_view(portfolio) }
  end

  def only_portfolio_view(portfolio)
    {
      id: portfolio.id,
      title: portfolio.title,
      name: portfolio.name,
      mobile: portfolio.mobile,
      email: portfolio.email,
      gender: portfolio.gender,
      birthday: portfolio.birthday,
      address: portfolio.address,
      memo: portfolio.memo,
      public_code: portfolio.public_code,
      created_at: portfolio.created_at,
      updated_at: portfolio.updated_at  
    }
  end

  def portfolio_view(portfolio)
    portfolio_skills = Portfolio::Skill.where(portfolio: portfolio).order(updated_at: :desc)
    portfolio_educations = Portfolio::Education.where(portfolio: portfolio).order(updated_at: :desc)
    portfolio_projects = Portfolio::Project.where(portfolio: portfolio).order(updated_at: :desc)
    portfolio_careers = Portfolio::Career.where(portfolio: portfolio).order(updated_at: :desc)

    {
      id: portfolio.id,
      title: portfolio.title,
      name: portfolio.name,
      mobile: portfolio.mobile,
      email: portfolio.email,
      gender: portfolio.gender,
      birthday: portfolio.birthday,
      address: portfolio.address,
      memo: portfolio.memo,
      public_code: portfolio.public_code,
      created_at: portfolio.created_at,
      updated_at: portfolio.updated_at,
      portfolio_skills: portfolio_skills_view(portfolio_skills),
      portfolio_educations: portfolio_educations_view(portfolio_educations),
      portfolio_projects: portfolio_projects_view(portfolio_projects),
      portfolio_careers: portfolio_careers_view(portfolio_careers)      
    }
  end

  def portfolio_skills_view(portfolio_skills)
    portfolio_skills.map { |portfolio_skill| portfolio_skill_view(portfolio_skill) }
  end

  def portfolio_skill_view(portfolio_skill)
    {
      id: portfolio_skill.id,
      name: portfolio_skill.name,
      level: portfolio_skill.level,
      created_at: portfolio_skill.created_at,
      updated_at: portfolio_skill.updated_at
    }
  end

  def portfolio_educations_view(portfolio_educations)
    portfolio_educations.map { |portfolio_education| portfolio_education_view(portfolio_education) }
  end

  def portfolio_education_view(portfolio_education)
    {
      id: portfolio_education.id,
      name: portfolio_education.name,
      status: portfolio_education.status,
      start_date: portfolio_education.start_date,
      end_date: portfolio_education.end_date,
      created_at: portfolio_education.created_at,
      updated_at: portfolio_education.updated_at
    }
  end

  def portfolio_projects_view(portfolio_projects)
    portfolio_projects.map { |portfolio_project| portfolio_project_view(portfolio_project) }
  end

  def portfolio_project_view(portfolio_project)
    {
      id: portfolio_project.id,
      name: portfolio_project.name,
      description: portfolio_project.description,
      created_at: portfolio_project.created_at,
      updated_at: portfolio_project.updated_at
    }
  end

  def portfolio_careers_view(portfolio_careers)
    portfolio_careers.map { |portfolio_career| portfolio_career_view(portfolio_career) }
  end

  def portfolio_career_view(portfolio_career)
    {
        id: portfolio_career.id,
        name: portfolio_career.name,
        description: portfolio_career.description,
        start_date: portfolio_career.start_date,
        end_date: portfolio_career.end_date,
        created_at: portfolio_career.created_at,
        updated_at: portfolio_career.updated_at
    }
  end

end


    