require "capybara/rspec"

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    if config.use_transactional_fixtures?
      fail(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    #ActiveRecord::Base.logger = Logger.new($stdout)
    ActiveRecord::Base.establish_connection "#{Rails.env}_vacols".to_sym
    DatabaseCleaner.clean_with(:truncation)
    ActiveRecord::Base.establish_connection "#{Rails.env}".to_sym
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    ActiveRecord::Base.establish_connection "#{Rails.env}_vacols".to_sym
    DatabaseCleaner.strategy = :transaction
    ActiveRecord::Base.establish_connection "#{Rails.env}".to_sym
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, db_clean: :truncation) do
    ActiveRecord::Base.establish_connection "#{Rails.env}_vacols".to_sym
    DatabaseCleaner.strategy = :truncation
    ActiveRecord::Base.establish_connection "#{Rails.env}".to_sym
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      ActiveRecord::Base.establish_connection "#{Rails.env}_vacols".to_sym
      DatabaseCleaner.strategy = :truncation
      ActiveRecord::Base.establish_connection "#{Rails.env}".to_sym
      DatabaseCleaner.strategy = :truncation
    end

  end

  config.before(:each) do
    ActiveRecord::Base.establish_connection "#{Rails.env}_vacols".to_sym
    DatabaseCleaner.start
    ActiveRecord::Base.establish_connection "#{Rails.env}".to_sym
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    ActiveRecord::Base.establish_connection "#{Rails.env}_vacols".to_sym
    DatabaseCleaner.clean
    ActiveRecord::Base.establish_connection "#{Rails.env}".to_sym
    DatabaseCleaner.clean
    reset_application!
  end
end
