class CareerController < ApiController

  before_action :validate_authorization

  # GET /careers
  def index
    careers = Career.find_by(user_id: current_user.id)
    json(data: { careers: careers })
  end

  #Get /careers/:id
  def show
    validate_params_id
    career = Career.find_by(id: params[:id], user_id: current_user.id)
    raise Exceptions::NotFound, '찾을 수 없는 경력입니다' unless career
    json( data: { career: career })
  end

  # POST /careers
  def create
    validate_career_params
    Career.create(name: params[:name], description: params[:description], start_date: params[:start_date], end_date: params[:end_date])
  end

  # PUT /careers/:id
  def update
    validate_params_id
    career = Career.find_by(id: params[:id], user_id: current_user.id)
    raise Exceptions::NotFound, '찾을 수 없는 경력입니다' unless career

    career.update(name: params[:name], description: params[:description], start_date: params[:start_date], end_date: params[:end_date])

  end

  # DELETE /careers/:id
  def destroy
    validate_params_id
    career = Career.find_by(id: params[:id], user_id: current_user.id)
    raise Exceptions::NotFound, '찾을 수 없는 경력입니다' unless career
    career.destroy

  end

  def validate_params_id
    params.require(:id)
  end

  def validate_career_params
    params.require(:name)
    params.permit!(:name, :description, :start_date, :end_date)
  end

end