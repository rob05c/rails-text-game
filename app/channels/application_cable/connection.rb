module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :verified_user

    def connect
      logger.info "DEBUGA ApplicationCable.Connection.connect"
      self.verified_user = find_verified_user
      logger.info "DEBUGA ApplicationCable.Connection.connect vu '#{self.verified_user}'"
    end

    private

    def current_user
      logger.info "DEBUGA ApplicationCable.Connection.current_user"

      sessionx = Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
      # sessionx = Current.session
      # if sessionx == nil then
      #   logger.info "DEBUGA ApplicationCable.Connection.current_user sessionx nil"
      # end
      # logger.info "DEBUGA ApplicationCable.Connection.current_user sessionx '#{sessionx}'"

      user_id = sessionx[:user_id]
      # if user_id == nil then
      #   logger.info "DEBUGA ApplicationCable.Connection.current_user user_id nil"
      # else
      #   logger.info "DEBUGA ApplicationCable.Connection.current_user user_id #{user_id}"
      # end

      user_name = User.find(user_id).name
      # if user_name == nil then
      #   logger.info "DEBUGA ApplicationCable.Connection.current_user user_name nil"
      # else
      #   logger.info "DEBUGA ApplicationCable.Connection.current_user user_name #{user_name}"
      # end
      @current_user ||= User.find(user_id)
    end

    def find_verified_user
      current_user || reject_unauthorized_connection
    end
  end
end
