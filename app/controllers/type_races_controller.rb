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
    @template = TypeRaces.new(type_racer_params)
    respond_to do |format|
      if @template.save
        format.html { redirect_to  @template, notice: 'Text was successfully created.'}
        format.json { render json: { text: @template.text_area}, status: :created }
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @template = TypeRaces.find(params[:id])

  end

  private

  def  type_racer_params
    params.permit(:text_area, :wpm, :id)
  end

end

