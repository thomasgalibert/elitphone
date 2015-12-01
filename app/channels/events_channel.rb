class EventsChannel < ApplicationCable::Channel
  def follow(data)
      stop_all_streams
      stream_from "agendas:#{data['agenda'].to_i}"
    end

    def unfollow
      stop_all_streams
    end
end
