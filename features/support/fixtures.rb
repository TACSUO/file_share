#Seed the DB
Before do
  Fixtures.reset_cache
  ActiveSupport::TestCase.fixture_path = Rails.root.to_s + '/spec/fixtures/'
  fixtures_folder = File.join(Rails.root.to_s, 'spec', 'fixtures')
  fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  Fixtures.create_fixtures(fixtures_folder, fixtures)
end

at_exit do
  include FileUtils::Verbose
  fileroot_old = File.join Rails.root, "public/files"
  fileroot_new = File.join Rails.root, "public/files/general"
  filename = "somefile*.txt"
  files = Dir["#{fileroot_old}/#{filename}"] + Dir["#{fileroot_new}/#{filename}"]
  rm_f(files)
end