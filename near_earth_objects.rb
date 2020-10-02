require 'faraday'
require 'figaro'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  def self.find_neos_by_date(date)
    asteroids_list_data = get_list_data(date)

    parsed_asteroids_data = parse_asteroids_data(asteroids_list_data, date)

    formatted_asteroid_data = get_formatted_asteroid_data(parsed_asteroids_data)

    largest_asteroid_diameter = get_largest_asteroid_diameter(parsed_asteroids_data)

    total_number_of_astroids = parsed_asteroids_data.count

    {
      astroid_list: formatted_asteroid_data,
      biggest_astroid: largest_asteroid_diameter,
      total_number_of_astroids: total_number_of_astroids
    }
  end

  def self.get_list_data(date)
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    ).get('/neo/rest/v1/feed')
  end

  def self.parse_asteroids_data(asteroids_list_data, date)
    JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def self.get_formatted_asteroid_data(parsed_asteroids_data)
    parsed_asteroids_data.map do |astroid|
      {
        name: astroid[:name],
        diameter: "#{astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{astroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end
  end

  def self.get_largest_asteroid_diameter(parsed_asteroids_data)
    # require "pry"; binding.pry
    parsed_asteroids_data.map do |astroid|
      astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}
  end


end
