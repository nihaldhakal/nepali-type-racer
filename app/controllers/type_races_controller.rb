class TypeRacesController < ApplicationController
  # access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all

  def index
    @type_race = TypeRace.last
    if @type_race.present? and (@type_race.user_1_id.nil? or @type_race.user_2_id.nil?)
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
  end

  # def start_or_join_request
  #   @type_race = TypeRace.create(user_id: current_user)
  #   user_count =  TypeRace.find(User.count)
  #   if time_count== false && user_count >=1
  #     create_or_join
  #   else
  #     update
  #     start_or_join_request
  #   end
  # end

  def create_or_join
    pending_race = TypeRace.pending.last
    # if pending_race && pending_race.time_remaining?
    if pending_race
      pending_race.update(user_2_id: current_user.id, status: "ongoing")
      pending_race.update(type_race_params)
      redirect_to type_race_path(pending_race)
      # if time_count == true
      #   join_race # use if additional logic needed
    else
      templates = RaceTemplate.all.sample.id
      type_race = TypeRace.create(user_1_id: current_user.id, user_2_id: nil, race_templates_id: templates)
      redirect_to type_race_path(type_race)
    end
  end

  def fetch_progress

  end

  def update_progress
    type_race = TypeRace.find(params[:id])
    return if type_race.nil?
    if type_race.status == "ongoing"
      type_race.update(type_race_params)
    end
  end

  private

  def type_race_params
    params.require(:type_race).permit(:user_1_progress, :user_2_progress, :user_1_accuracy, :user_2_accuracy, :user_1_wpm, :user_2_wpm )
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

