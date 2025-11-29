# config/initializers/secure_headers.rb
SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true,
    httponly: true,
    samesite: {
      lax: true # or :strict
    }
  }

  config.hsts = "max-age=#{1.year.to_i}" # HSTS for 1 year
  config.x_frame_options = "DENY" # Prevent clickjacking
  config.x_content_type_options = "nosniff" # Prevent MIME type sniffing
  config.x_xss_protection = "1; mode=block" # XSS filter for older IE/Chrome
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  if Rails.env.development?
    # Disable the header entirely in dev
    config.csp = SecureHeaders::OPT_OUT
  else
    config.csp = {
      # 'meta' values: these shape the header, but are not included in the header.
      preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.
      disable_nonce_backwards_compatibility: true, # If false, `unsafe-inline` will be added automatically when using nonces.

      # directive values: these values will directly translate into source directives
      default_src: %w['none'], # Start strict!
      base_uri: %w['self'],
      child_src: %w['self'],
      connect_src: %w['self' wss:], # Add any WebSocket or API domains
      font_src:    %w['self' https: data: fonts.cdnfonts.com fonts.gstatic.com],
      form_action: %w['self'],
      frame_ancestors: %w['none'],
      img_src: %w['self' data: validator.swagger.io], # For local images and data URIs
      manifest_src: %w['self'],
      media_src: %w['self'],
      object_src: %w['none'],
      script_src: %w['self' https: 'unsafe-inline'], # 'strict-dynamic' allows scripts loaded by trusted scripts
      script_src_elem: %w['self' 'unsafe-inline' demo.senteflow.com],
      style_src:   %w['self' https: 'unsafe-inline' fonts.googleapis.com fonts.cdnfonts.com]
      # report_uri: %w[https://your-csp-report-endpoint.com/report]
    }
  end
end
