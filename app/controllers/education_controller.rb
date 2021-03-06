# frozen_string_literal: true

# 학력 조회/생성/수정/삭제 기능을 관리하는 컨트롤러
class EducationController < ApiController
  before_action :validate_authorization

  STATUS = Education::STATUS

  # GET /educations
  def index
    educations = Education.where(user: current_user).order(updated_at: :desc)
    json(data: { educations: educations_view(educations) })
  end

  # POST /educations
  def create
    params.require(:name)
    params.require(:status)
    params.require(:start_date)
    unless params.key?(:end_date)
      raise Exceptions::BadRequest, 'end_date 파라미터가 누락되었습니다'
    end

    education = Education.create!(user: current_user, name: params[:name],
                                  status: params[:status], start_date: params[:start_date],
                                  end_date: params[:end_date])

    json(data: { education: education_view(education) })
  end

  # PUT /educations/:id
  def update
    params.require(:id)

    if params.key?(:name) && params[:name].blank?
      raise Exceptions::BadRequest, '학교명을 비울 수 없습니다'
    end

    if params.key?(:status) && !params[:status].in?(STATUS)
      raise Exceptions::BadRequest, '졸업구분을 비울 수 없습니다'
    end

    if params.key?(:start_date) && params[:start_date].blank?
      raise Exceptions::BadRequest, '입학일자를 비울 수 없습니다'
    end

    education = Education.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound, '학력이 존재하지 않습니다' unless education

    education.name = params[:name] if params.key?(:name)
    education.status = params[:status] if params.key?(:status)
    education.start_date = params[:start_date] if params.key?(:start_date)
    education.end_date = params[:end_date] if params.key?(:end_date)
    education.save!

    json(data: { education: education_view(education) })
  end

  # DELETE /educations/:id
  def destroy
    params.require(:id)

    education = Education.find_by(id: params[:id], user: current_user)
    raise Exceptions::NotFound, '학력이 존재하지 않습니다' unless education

    education.destroy

    json(code: 200)
  end

  private

  def educations_view(educations)
    educations.map { |education| education_view(education) }
  end

  def education_view(education)
    {
      id: education.id,
      name: education.name,
      status: education.status,
      start_date: education.start_date,
      end_date: education.end_date,
      created_at: education.created_at,
      updated_at: education.updated_at
    }
  end

end