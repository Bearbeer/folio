# frozen_string_literal: true

# 회원가입/탈퇴 기능을 관리하는 컨트롤러
class ProjectController < ApiController
  before_action :validate_authorization

  # POST /projects
  def create
    params.require(:name)

    project = Project.create!(user: current_user, name: params[:name], description: params[:description])


    json(data: { user: user_view(user), session: session_view(user) })
  end

  # PUT /projects/:id
  def update
    params.require(:name)


  end

  # DELETE /projects/:id
  def destroy
    params.require(:id)

    project = Project.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound, '프로젝트가 존재하지 않습니다' unless project

    project.destroy

    json(message: '프로젝트를 삭제하였습니다')
  end

  private

  def project_view(project)
    {
      id: project.id,
      name: project.name,
      description: project.description,
      created_at: project.created_at
    }
  end
end