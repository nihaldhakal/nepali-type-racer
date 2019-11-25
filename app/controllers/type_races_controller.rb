class TypeRacesController < ApplicationController
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all

  def index

  end

  def new
    @templates = RaceTemplate.all.sample
    @type_race = TypeRaces.create(user_id: current_user)
  end

  def create
    @type_racer = TypeRaces.new(type_racer_params)
    respond_to do |format|
      if @type_racer.save
        format.html { redirect_to  @type_racer, notice: 'Text was successfully created.'}

        format.json { render json: { text: @type_racer.text_area}, status: :created }
      else
        format.html { render :new }
        format.json { render json: @type_racer.errors, status: :unprocessable_entity }
      end
    end
  end

  def start_or_join
    @type_racer = TypeRaces.find(params[:id])
    if @type_racer.pending?
      if time_counting > 3
      end
    end
  end

  def update
    @type_racer = TypeRaces.find(params[:id])
    respond_to do |format|
    if @type_racer.update_attribute(:text_area, type_racer_params[:text_area])
      format.json { render json: { text: @type_racer.text_area}, status: :ok}
    end
    end
  end

  private

  def  type_racer_params
    params.permit(:text_area, :wpm, :id, :status)
  end

  def time_counting
    time_count_in_seconds = 0
    10.downto(0) do |index|
      puts index
      sleep 1
      time_count_in_seconds =index
    end
    return time_count_in_seconds
  end

end

