module FileShare
  class Engine < Rails::Engine
    ASSET_PREFIX = "file_share"

    initializer "file_share.asset_path" do |app|
      app.config.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
  end
end
