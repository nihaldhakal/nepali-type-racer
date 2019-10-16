class RaceTemplatesController < ApplicationController
  def index
    @race = RaceTemplate.all
  end

  def show
    @race = RaceTemplate.find(params[:id])
  end

  def new
    @race = RaceTemplate.new
  end


  def edit
    @race = RaceTemplate.find(params[:id])
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
    @race = RaceTemplate.find(params[:id])
    if @race.update_attributes(race_template_params)
      flash[:success] = "Text updated"
      redirect_to @race
    else
      flash[:danger] = "Text cannot be updated"
    end
  end

  def destroy
    @race = RaceTemplate.find(params[:id]).destroy
    redirect_to race_templates_path
  end

  private

  def race_template_params
    params.require(:race_template).permit(:text)
  end

end
