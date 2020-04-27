# frozen_string_literal: true

# 중앙 프로젝트 관리 기능을 관리하는 컨트롤러
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
    project = Project.create! attributes.merge(user: current_user)

    json(data: { project: project_view(project) })
  end

  # PUT /projects/:id
  def update
    validate_update_params
    find_and_validate_project
    update_project

    json(data: { project: project_view(@project) })
  end

  # DELETE /projects/:id
  def destroy
    params.require(:id)
    find_and_validate_project
    @project.destroy

    json(code: 200)
  end

  private

  def validate_update_params
    params.require(:id)
    return unless params.key?(:name) && params[:name].blank?

    raise Exceptions::BadRequest, '프로젝트 명을 지울 수는 없습니다'
  end

  def find_and_validate_project
    @project = Project.find_by(id: params[:id], user: current_user)

    raise Exceptions::NotFound, '프로젝트가 존재하지 않습니다' unless @project
  end

  def attributes
    @attributes ||= params.permit(:name, :description).to_h.compact
  end

  def update_project
    return if attributes.blank?

    @project.update! attributes
  end

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