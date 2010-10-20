#Seed the DB
Before do
  Fixtures.reset_cache
  ActiveSupport::TestCase.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  fixtures_folder = File.join(RAILS_ROOT, 'spec', 'fixtures')
  fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  Fixtures.create_fixtures(fixtures_folder, fixtures)
end