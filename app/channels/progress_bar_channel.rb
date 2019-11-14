class ProgressBarChannel < ApplicationCable::Channel
  def subscribed
    @type_races =  TypeRaces.find(params[:id])
    stream_for @type_races
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
