class TypeRacesController < ApplicationController
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all
  def index
    @type_race = TypeRace.last
    if @type_race.present?
      @type_race.update(status: "canceled")
      if user_logged_in? && @type_race.canceled?
        destroy_race
      end
    end
  end

  def show
    @type_race = TypeRace.find(params[:id])
    @templates = RaceTemplate.find_by_id(@type_race.race_templates_id)
    @type_race_stat = @type_race.type_race_stats.find_by(user_id: current_user.id)
    if @type_race.status == "countdown_is_set"
      @users = TypeRace.last.users
    end
    if @type_race.status == "countdown_is_set" and Time.now-@type_race.countdown_started >11
      @type_race.update(status: "ongoing")
    end
    respond_to  do |format|
      format.html
      format.js do
        render json: @type_race
      end
    end
  end

  def create_or_join
    type_race_stat_last = TypeRaceStat.last
    if race = (TypeRace.countdown_is_set.last || TypeRace.pending.last)
      type_race_stat = TypeRaceStat.create(user_id: current_user.id, type_race_id: type_race_stat_last.type_race_id)
      race.update(status: "countdown_is_set", countdown_started: Time.now) if race.pending?
    else
      templates = RaceTemplate.all.sample.id
      race = TypeRace.create(race_templates_id: templates)
      type_race_stat = TypeRaceStat.create(type_race_id: race.id, user_id: current_user.id)
    end
    redirect_to type_race_path(race)
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
    10.downto(0) do |index|
      sleep 1
      @time_count_in_seconds =index
    end
  end

  # def start
  #   count_down_is_set = TypeRace.countdown_is_set.last
  #   if @time_count_in_seconds <= 0
  #     count_down_is_set.update(status: "ongoing")
  #   end
  #
  #   if @time_count_in_seconds <= 3
  #     # Don't let users to enter the race
  #     redirect_to type_races_create_or_join_path
  #   end
  # end

end

