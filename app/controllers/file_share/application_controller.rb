class FileShare::ApplicationController < ApplicationController
  protect_from_forgery
  
  prepend_before_filter :use_engine_assets if Rails.env != 'production'
  prepend_before_filter :setup_asset_path if defined?(FileShare::Engine)

  helper_method :engine_path
  
  private
    def use_engine_assets
      require 'file_share/action_view'
    end
    def setup_asset_path
      config.asset_path = '/file_share%s'
    end
  protected
  public
end
