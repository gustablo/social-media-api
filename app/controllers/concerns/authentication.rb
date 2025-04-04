require_relative "./jwt_handler"

module Authentication
  extend ActiveSupport::Concern
  include JWTHandler

  included do
    before_action :require_authentication
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= current_session
    end

    def request_authentication
      render json: { error: "Authentication required." }, status: :unauthorized
    end

    def start_new_session_for(user)
      session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
      encode(session)
    end

    def terminate_session
      current_session.destroy
    end

    def current_session
      token = request.headers["Authorization"]&.split("Bearer ")&.last
      return unless token

      session_id = decode(token)&.id
      return unless session_id

      Session.find_by_id(session_id)
    end
end
