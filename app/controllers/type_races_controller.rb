# frozen_string_literal: true

# Class for type race.
class TypeRacesController < ApplicationController
  before_action :fetch_current_type_race, only:  [:show, :fetch_progress, :update_progress]
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all
  def index
    TypeRace.delete_pending_race
    TypeRace.delete_countdown_is_set_and_ongoing_race
  end

  def show
    @templates = RaceTemplate.find_by_id(@type_race.race_templates_id)
    @type_race_stat = @type_race.type_race_stats.find_by(user_id: current_user.id)
    @users = @type_race.users
    # if @type_race.status == "countdown_is_set" or @type_race.ongoing?
    #   @type_race_stat.update(status: "left")
    # end
    @type_race.countdown_has_ended?
    respond_to do |format|
      format.html
      format.js do
        render json: @type_race
      end
    end
  end

  def create_or_join
    redirect_to TypeRace.create_or_join_race(current_user.id)
  end

  def fetch_progress
    respond_to  do |format|
      format.js do
        render json: @type_race.type_race_stats
      end
    end
  end

  def update_progress
    @type_race.update_race_stats(current_user.id, type_race_stat_params)
    respond_to  do |format|
      format.js do
        render json: @type_race.type_race_stats
      end
    end
  end

  private

  def fetch_current_type_race
    @type_race = TypeRace.find(params[:id])
  end

  def type_race_stat_params
    params.require(:type_race_stat).permit(:progress, :accuracy, :wpm)
  end

end
