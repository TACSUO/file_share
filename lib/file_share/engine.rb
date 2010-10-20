require "file_share"
require "rails"

module FileShare
  class Engine < Rails::Engine
    ASSET_PREFIX = "file_share"
    ENGINEER_VERSION = "0.2.3"

    initializer "file_share.require_dependencies" do
      require 'bundler'
      gemfile = Bundler::Definition.build(root.join('Gemfile'), root.join('Gemfile.lock'), {})
      specs = gemfile.dependencies.select do |d|
        d.name != 'engineer' and (d.groups & [:default, :production]).any?
      end

      specs.collect { |s| s.autorequire || [s.name] }.flatten.each do |r|
        require r
      end
    end

    initializer "file_share.action_view.identifier_collection" do
      require 'file_share/action_view'
    end

    initializer "file_share.asset_path" do
      require 'file_share/asset_path'
      setup_asset_path
    end
  end
end