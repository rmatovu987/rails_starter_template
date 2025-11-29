Rails.application.config.session_store :cookie_store,
                                       key: "_kas3ef4r4_session",
                                       expire_after: 1.day,
                                       secure: Rails.env.production?,
                                       httponly: true,
                                       same_site: :lax

module SessionConfig
  SESSION_TIMEOUT = 10.minutes
end
