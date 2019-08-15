class BroadcastRelayJob < ApplicationJob
  def perform(options)
    # uid = options.delete('uid')

    # ActionCable.server.broadcast("notifications:#{uid}", **options)
  end
end