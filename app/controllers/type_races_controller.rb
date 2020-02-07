class TypeRacesController < ApplicationController
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all
  def index
    @type_race = TypeRace.last
    if @type_race.present?
      @type_race.update_attribute(:status ,"canceled")
      if user_logged_in? && @type_race.canceled?
        destroy_race
      end
    end
  end

  def show
    #Get template_id same as race_template_id
    # @templates = RaceTemplate.find_by(params[:template])
    @type_race = TypeRace.find(params[:id])
    @templates = RaceTemplate.find_by_id(@type_race.race_templates_id)
    @type_race_stat = @type_race.type_race_stats.find_by(user_id: current_user.id)
    # @type_race_stat_arr.each do |type_race_stat|
    #   debugger
    #   if type_race_stat.user_id == current_user.id
    #     @type_race_stat = type_race_stat
    #   end
    # end
    if @type_race.status == "ongoing"
      @users = TypeRace.last.users
    end
  end

  def create_or_join
    pending_race = TypeRace.pending.last
    type_race_stat_last = TypeRaceStat.last
    # if pending_race && pending_race.time_remaining?
    if pending_race
      pending_race.update(status: "ongoing")
      type_race_stat =TypeRaceStat.create(user_id: current_user.id, type_race_id: type_race_stat_last.type_race_id)
      redirect_to type_race_path(pending_race)
      # if time_count == true
      #   join_race # use if additional logic needed
    else
      templates = RaceTemplate.all.sample.id
      type_race = TypeRace.create(race_templates_id: templates)
      type_race_stat = TypeRaceStat.create(type_race_id: type_race.id, user_id: current_user.id)
      redirect_to type_race_path(type_race)
    end
  end

  def fetch_progress
    @type_race = TypeRace.find(params[:id])
    respond_to  do |format|
      format.js do
        render json: @type_race.type_race_stats
      end
    end
  end

  def update_progress
    type_race = TypeRace.find(params[:id])
    return if type_race.nil?
    if type_race.status == "ongoing"
      type_race_stat = type_race.type_race_stats.find_by(user_id: current_user.id)
      type_race_stat.update(type_race_stat_params)
    end
    render json: {}, status: :ok
  end

  private

  def type_race_stat_params
    params.require(:type_race_stat).permit(:progress, :accuracy, :wpm )
  end

  def destroy_race
    if @type_race.status == "canceled"
      @type_race.destroy
    end
  end

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

