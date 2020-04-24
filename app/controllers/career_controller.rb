class CareerController < ApiController

  before_action :validate_authorization

  # GET /careers
  def index
    careers = Career.where(user: current_user).order(updated_at: :desc)
    json(data: { careers: careers_view(careers) })
  end

  # Get /careers/:id
  def show
    params.require(:id)
    career = get_career_by_id params[:id]
    json(data: { career: career_view(career) })
  end

  # POST /careers
  def create
    validate_career_params
    career = Career.create!(user_id: current_user.id, name: params[:name], description: params[:description], start_date: params[:start_date], end_date: params[:end_date])

    json(code: 200, data: { career: career_view(career) })
  end

  # PUT /careers/:id
  def update
    params.require(:id)
    validate_career_params
    career = get_career_by_id params[:id]
    career.update!(name: params[:name], description: params[:description], start_date: params[:start_date], end_date: params[:end_date])

    json(code: 200, data: { career: career_view(career) })

  end

  # DELETE /careers/:id
  def destroy
    params.require(:id)
    career = get_career_by_id params[:id]
    career.destroy

    json(code: 200)

  end

  private

  def validate_career_params
    params.require(:name)
    params.permit(:name, :description, :start_date, :end_date)
  end

  def get_career_by_id(career_id)
    career = Career.find_by(id: career_id, user_id: current_user.id)
    raise Exceptions::NotFound, '찾을 수 없는 경력입니다' unless career

    career
  end

  def career_view(career)
    {
        id: career.id,
        name: career.name,
        description: career.description,
        start_date: career.start_date,
        end_date: career.end_date,
        created_at: career.created_at,
        updated_at: career.updated_at
    }
  end

  def careers_view(careers)
    careers.map { |career| career_view(career) }
  end
end