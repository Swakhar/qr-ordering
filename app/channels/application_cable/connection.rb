module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # Allow anonymous connections for kitchen display
    # No authentication required - anyone can view the kitchen display
    def connect
      logger.add_tags 'ActionCable'
    end
  end
end
