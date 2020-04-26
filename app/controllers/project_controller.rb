# frozen_string_literal: true

# 회원가입/탈퇴 기능을 관리하는 컨트롤러
class ProjectController < ApiController
  before_action :validate_authorization

  # GET /projects
  def index
    projects = Project.where(user: current_user).order(updated_at: :desc)

    json(data: { projects: projects_view(projects) })
  end

  # POST /projects
  def create
    params.require(:name)
    description = '' unless params[:description].present?

    project = Project.create!(user: current_user, name: params[:name],
                              description: description)

    json(data: { project: project_view(project) })
  end

  # PUT /projects/:id
  def update
    params.require(:id)
    if params.key?(:name) && params[:name].blank?
      raise Exceptions::BadRequest, '프로젝트 명을 지울 수는 없습니다'
    end

    project = Project.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound, '프로젝트가 존재하지 않습니다' unless project

    project.name = params[:name] if params.key?(:name)
    project.description = params[:description] if params.key?(:description)
    project.save!

    json(data: { project: project_view(project) })
  end

  # DELETE /projects/:id
  def destroy
    params.require(:id)

    project = Project.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound, '프로젝트가 존재하지 않습니다' unless project

    project.destroy

    json(code: 200)
  end

  private

  def projects_view(projects)
    projects.map { |project| project_view(project) }
  end

  def project_view(project)
    {
      id: project.id,
      name: project.name,
      description: project.description,
      created_at: project.created_at,
      updated_at: project.updated_at
    }
  end
end