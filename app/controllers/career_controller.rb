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
    career = get_career_by_id(params[:id])

    json(data: { career: career_view(career) })
  end

  # POST /careers
  def create
    attributes = prepare_create_params
    career = Career.create!(attributes)

    json(code: 200, data: { career: career_view(career) })
  end

  # PUT /careers/:id
  def update
    attributes = prepare_update_params
    career = get_career_by_id(params[:id])
    career.update!(attributes)

    json(code: 200, data: { career: career_view(career) })
  end

  # DELETE /careers/:id
  def destroy
    params.require(:id)
    career = get_career_by_id(params[:id])
    career.destroy

    json(code: 200)
  end

  private

  def validate_create_params
    params.require(:name)
    params.require(:start_date)
  end

  def prepare_create_params
    validate_create_params
    params[:description] = '' unless params[:description].present?
    params[:user_id] = current_user.id

    params.permit(:user_id, :name, :description, :start_date, :end_date)
          .to_h.compact
  end

  def validate_update_params
    params.require(:id)
  end

  def prepare_update_params
    validate_update_params
    params[:description] = '' unless params[:description].present?

    params.permit(:name, :description, :start_date, :end_date)
          .to_h.compact
  end

  def get_career_by_id(career_id)
    career = Career.find_by(id: career_id, user: current_user)
    raise Exceptions::NotFound, '찾을 수 없는 경력입니다' unless career

    career
  end

  def careers_view(careers)
    careers.map { |career| career_view(career) }
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


end