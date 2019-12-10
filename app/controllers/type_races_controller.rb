class TypeRacesController < ApplicationController
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all

  def index

  end

  # def new
  #   @templates = RaceTemplate.all.sample
  #   @type_race = TypeRace.create(user_id: current_user)
  # end
  #
  # def create
  #   @type_racer = TypeRace.new(type_racer_params)
  #   respond_to do |format|
  #     if @type_racer.save
  #       format.html { redirect_to  @type_racer, notice: 'Text was successfully created.'}
  #
  #       format.json { render json: { text: @type_racer.text_area}, status: :created }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @type_racer.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def show
    @templates = RaceTemplate.all.sample
    @type_race = TypeRace.create(user_id: current_user)
    user_count =  TypeRace.find(User.count)
    if time_count== false && user_count >1
      create_or_join
    else

    end
  end

  def create_or_join
    debugger
    pending_race = TypeRace.pending.last
    if pending_race
      # if time_count == true
      #   join_race # use if additional logic needed
      pending_race.users.add(current_user)
      type_race = pending_race
      # else
      #   create
      # end
    else
      type_race = TypeRace.create(type_racer_params )
      type_race.users.add(current_user)
      # create
    end
    redirect_to type_race
  end

  def update
    @type_racer = TypeRace.find(params[:id])
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

  def time_count
    time_count_in_seconds = 0
    10.downto(0) do |index|
      sleep 1
      time_count_in_seconds =index
      if time_count_in_seconds > 3
        return true
      end
    end
  end


end

