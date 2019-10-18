class RaceTemplatesController < ApplicationController
  before_action :set_race, except: [:index, :new, :create]
  before_action :is_published_check, only: [:destroy, :update]

  def index
    @race = RaceTemplate.all
  end

  def show
  end

  def new
    @race = RaceTemplate.new
  end


  def edit
  end

  def create
    @race = RaceTemplate.new(race_template_params)
    respond_to do |format|
      if @race.save
        format.html { redirect_to  @race, notice: 'Race template was successfully created.'}
        format.json { render :show, status: :created, location: @race }
      else
        format.html { render :new }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    debugger
    if @race.update_attributes(race_template_params)
      flash[:success] = "Text updated"
      redirect_to @race
    else
      flash.now[:danger] = "Text cannot be updated"
      render 'edit'
    end
  end

  def destroy
    @race.destroy
    redirect_to race_templates_path
  end

  # def set_is_publish
  #   @race.update_attribute(:is_published, true)
  # end


  private

  def race_template_params
    params.require(:race_template).permit(:text, :is_published)
  end

  def set_race
    @race = RaceTemplate.find_by(id: params[:id])
  end

  def is_published_check
    if @race.is_published?
      redirect_to race_template_path, notice: "Can't be updated or deleted once published"
    end
  end

end
