class TypeRacesController < ApplicationController
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all

  def index

  end

  def new
    @templates = RaceTemplate.all.sample
    @type_racer = TypeRaces.new
    # @template = TypeRaces.create(user: current_user)
    # redirect_to type_races_edit_path(@template)
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

  def update
    @type_racer = TypeRaces.find(params[:id])
  end

  private

  def  type_racer_params
    params.permit(:text_area, :wpm, :id)
  end

end

