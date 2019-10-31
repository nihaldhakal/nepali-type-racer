class TypeRacesController < ApplicationController
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all

  def index
    @templates = RaceTemplate.all.sample
  end

  def new
    @template = TypeRaces.new
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @text.to_json}
    # end
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

  private
  def  type_racer_params

    params.permit(:text_area)
  end
end

