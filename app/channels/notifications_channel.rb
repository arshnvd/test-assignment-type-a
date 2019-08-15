class NotificationsChannel < ApplicationCable::Channel
  def unsubscribed
    stop_all_streams
  end

  def listen(data)
    channel = "notifications:#{data['gid']}"
    stream_from(channel)
  end
end