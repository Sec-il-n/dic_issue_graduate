Rails.application.configure do

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  # config.consider_all_requests_local = false
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # ActionMailerのviewで直接URLを表示するとき
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  # config.action_mailer.delivery_method = :ses
  config.action_mailer.delivery_method = :smtp
  # config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    # # エンドポイント https://docs.aws.amazon.com/ja_jp/general/latest/gr/ses.html
    # :address => 'email.ap-northeast-1.amazonaws.com',
    # g-mailのエンドポイント
    address: 'smtp.gmail.com',
    # SMTP-AUTH認証　STARTTLSを使うので587番ポート
    port: 587,
    authentication: :login,
    domain: 'gmail.com',
    # domain: 'suggests-met.xyz',
    # user_name: Rails.application.credentials.dig(:aws, :ses_smtp_usesr),
    # password: Rails.application.credentials.dig(:aws, :ses_smtp_password)
    user_name: Rails.application.credentials.dig(:gmail, :user_name),
    password: Rails.application.credentials.dig(:gmail, :password)
    # # STARTTLSを使うのでtrue
    # :enable_starttls_auto => true
  }


  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
