require "jwt"

module JwtHandler 
  extend ActiveSupport::Concern

  def encode(session)
    payload = session.as_json
    JWT.encode(payload, nil, "none")
  end

  def decode(token)
    begin
      decoded_token = JWT.decode(token, nil, false)
      session_id = decoded_token[0]["id"]
      Session.find(session_id)
    rescue JWT::DecodeError
      nil
    rescue StandardError
      nil
    end
  end
end
