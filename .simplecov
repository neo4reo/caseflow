if ENV["RAILS_ENV"] == "test"
  SimpleCov.start do
    add_filter "app/services/test_data_service.rb"
    add_filter "lib/fakes"
    add_filter "lib/generators"
    add_filter "spec/support"
    add_filter "config/initializers"
    add_filter "config/environments/test.rb"
    add_filter "lib/tasks"
  end
  SimpleCov.coverage_dir ENV["COVERAGE_DIR"] || nil
  SimpleCov.command_name ENV["TEST_SUBCATEGORY"] || "all"
  if ENV["CIRCLE_NODE_INDEX"]
    SimpleCov.command_name "RSpec" + ENV["CIRCLE_NODE_INDEX"]
  end
end

