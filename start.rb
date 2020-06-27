require_relative 'near_earth_objects'

class Start
  def initialize
    @date = nil
    @asteroid_details = nil
    run
  end

  def run
    puts "________________________________________________________________________________________________________________________________"
    puts "Welcome to NEO. Here you will find information about how many meteors, asteroids, comets pass by the earth every day.
          \nEnter a date below to get a list of the objects that have passed by the earth on that day."
    puts "Please enter a date in the following format YYYY-MM-DD."
    print ">>"

    @date = gets.chomp
    objects = NearEarthObjects.new(@date)
    @asteroid_details = objects.get_formatted_neos_data

    puts "______________________________________________________________________________"
    puts "On #{format_date}, there were #{@asteroid_details[:total_number_of_asteroids]} objects that almost collided with the earth."
    puts "The largest of these was #{@asteroid_details[:biggest_asteroid]} ft. in diameter."
    puts "\nHere is a list of objects with details:"

    build_list
  end

  def format_date
    DateTime.parse(@date).strftime("%A %b %d, %Y")
  end

  def build_list
    column_labels = { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
    column_data = column_labels.each_with_object({}) do |(col, label), hash|
      hash[col] = {
        label: label,
        width: [@asteroid_details[:asteroid_list].map { |asteroid| asteroid[col].size }.max, label.size].max
      }
    end

    header = "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
    divider = "+-#{column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"

    puts divider
    puts header
    create_rows(@asteroid_details[:asteroid_list], column_data)
    puts divider
  end

  def create_rows(asteroid_data, column_info)
    asteroid_data.each { |asteroid| format_row_data(asteroid, column_info) }
  end

  def format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end
end
