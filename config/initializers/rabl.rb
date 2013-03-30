Rabl.configure do |config|
  config.include_json_root = false
  config.cache_all_output = true
  config.cache_sources = Rails.env.to_s != 'development'
  config.view_paths = [Rails.root.join('app/views')]
end
