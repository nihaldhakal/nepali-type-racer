class TypeRacesController < ApplicationController
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all

  def index
    @type_race = TypeRace.where("user_1_id= #{current_user.id} or user_2_id=#{current_user.id}").last
    unless @type_race.nil?
      @type_race.update_attribute(:status ,"canceled")
      destroy_race
    end
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
    #Get template_id same as race_template_id
    # @templates = RaceTemplate.find_by(params[:template])
    # Used in show template.
    @type_race = TypeRace.find(params[:id])
    @templates = RaceTemplate.find_by_id(@type_race.race_templates_id)
  end

  def start_or_join_request
    @type_race = TypeRace.create(user_id: current_user)
    user_count =  TypeRace.find(User.count)
    if time_count== false && user_count >=1
      create_or_join
    else
      update
      start_or_join_request
    end
  end

  def create_or_join
    templates = RaceTemplate.all.sample.id
    pending_race = TypeRace.pending.last
    # if pending_race && pending_race.time_remaining?
    if pending_race
      # if pending_race.user_1_id == current_user.id || pending_race.user_1_id == nil
      if pending_race.user_1_id == current_user.id
        # debugger
        pending_race.update(status: "canceled")
      else
        pending_race.update(user_2_id: current_user.id, status: "ongoing")
        redirect_to type_race_path(pending_race)
      end
      # if time_count == true
      #   join_race # use if additional logic needed
    else
      type_race = TypeRace.create(user_1_id: current_user.id, user_2_id: nil, race_templates_id: templates)
      redirect_to type_race_path(type_race)
    end
  end

  def poll
    type_race = TypeRace.find(params[:id])
    return if type_race.nil?
    if type_race.status == "ongoing"
      redirect_to type_race_path(type_race)
    end
  end

  def destroy_race
    if @type_race.status == "canceled"
      @type_race.destroy
    end
  end
  # def update
  #   @type_racer = TypeRace.find(params[:id])
  #   respond_to do |format|
  #     if @type_racer.update_attribute(:text_area, type_racer_params[:text_area])
  #       format.json { render json: { text: @type_racer.text_area}, status: :ok}
  #     end
  #   end
  # end

  private

  # def  type_racer_params
  #   params.permit( :status,:user_1_id, :user_2_id)
  # end

  def time_count
    # time_count_in_seconds = 0
    10.downto(0) do |index|
      sleep 1
      # time_count_in_seconds =index
      if index > 3
        return true
      end
    end
  end
end

