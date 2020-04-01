class TypeRace < ApplicationRecord
  belongs_to :race_template, optional:true
  has_many :type_race_stats
  has_many :users, through: :type_race_stats
  enum status: [:pending,:countdown_is_set,:ongoing,:canceled, :completed]
  def self.delete_pending_race
    type_race_pending = TypeRace.pending
    # If there exist a pending race it will be deleted
    type_race_pending.delete_all if type_race_pending.present?
  end

  def self.delete_countdown_is_set_and_ongoing_race
    type_races = TypeRace.all
    type_race_ongoing_countdown_is_set = TypeRace.where(status: [:ongoing,:countdown_is_set])
    if type_races.present? && type_race_ongoing_countdown_is_set.present?
      # If countdown_is_set and ongoing and also the time taken is more than 3 minutes. Race must be deleted.
      type_race_ongoing_countdown_is_set.where("countdown_started < ?", Time.now - 180).delete_all
      # @type_race_ongoing_countdown_is_set.select do |delete_type_race|
      #   if (Time.now - delete_type_race.countdown_started > 180)
      #     delete_type_race.destroy
      #   end
      # end
    end
  end

  def countdown_has_ended?
    # Class instance method
    self.update(status:"ongoing") if self.status == 'countdown_is_set' && Time.now - self.countdown_started > 11
  end

  def self.create_or_join_race(current_user)
    @type_race_countdown_is_set = TypeRace.find_by(status: 'countdown_is_set')
    if (race = TypeRace.find_by(status: 'pending'))
      unless race.type_race_stats.find_by(user_id: current_user).present?
        type_race_stat_race_id = TypeRaceStat.find_by(type_race_id: race.id)
        TypeRaceStat.create(user_id: current_user, type_race_id: type_race_stat_race_id.type_race_id)
        race.update(status: 'countdown_is_set', countdown_started: Time.now)
      end
    elsif @type_race_countdown_is_set && (@type_race_countdown_is_set.type_race_stats.count(:user_id) < 3)
      race = @type_race_countdown_is_set
      unless race.type_race_stats.find_by(user_id: current_user).present?
        type_race_stat_race_id = TypeRaceStat.find_by(type_race_id: race.id)
        TypeRaceStat.create(user_id: current_user, type_race_id: type_race_stat_race_id.type_race_id)
      end
    else
      templates = RaceTemplate.all.sample.id
      race = TypeRace.create(race_templates_id: templates)
      TypeRaceStat.create(type_race_id: race.id, user_id: current_user)
    end
    return race
  end

  def update_race_stats(current_user,type_race_stat_params)
    return if self.nil?

    type_race_stat = self.type_race_stats.find_by(user_id: current_user)
    if self.status == 'ongoing' || self.status == 'completed'
      type_race_stat.update(type_race_stat_params)
    end
    if (Time.now - self.countdown_started) < 180 && type_race_stat.progress == RaceTemplate.find_by(id:self.race_templates_id).text
      self.update(status: 'completed')
      type_race_stat.update(status: 'completed')
    end
    self.destroy if self.completed? == false && (Time.now - self.countdown_started) > 180
  end

end


