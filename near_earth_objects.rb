require 'faraday'
require 'figaro'
require 'pry'
class NearEarthObjects
  def initialize(date)
    # Load ENV vars via Figaro
    Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
    Figaro.load

    conn = Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
    asteroids_list_data = conn.get('/neo/rest/v1/feed')
    @parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def get_largest_asteroid_diameter
    @parsed_asteroids_data.map do |asteroid|
      asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}
  end

  def get_total_number_of_asteroids
    @parsed_asteroids_data.count
  end

  def get_formatted_asteroid_data
    @parsed_asteroids_data.map do |asteroid|
      {
        name: asteroid[:name],
        diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end
  end

  def get_formatted_neos_data
    {
      asteroid_list: get_formatted_asteroid_data,
      biggest_asteroid: get_largest_asteroid_diameter,
      total_number_of_asteroids: get_total_number_of_asteroids
    }
  end
end
