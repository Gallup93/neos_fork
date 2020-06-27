require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def setup
    @neos_test_date = NearEarthObjects.new('2019-03-30')
  end

  def test_initialization
    assert_instance_of NearEarthObjects, @neos_test_date
  end

  def test_a_date_returns_a_list_of_neos
    results = @neos_test_date.get_formatted_neos_data
    assert_equal '(2019 GD4)', results[:asteroid_list][0][:name]
  end

  def test_get_largest_asteroid_diameter
    assert_equal 10233, @neos_test_date.get_largest_asteroid_diameter
  end

  def test_get_total_number_of_asteroids
    assert_equal 12, @neos_test_date.get_total_number_of_asteroids
  end

  def test_get_formatted_asteroid_data
    expected1 = {:name=>"(2019 GD4)", :diameter=>"61 ft", :miss_distance=>"911947 miles"}
    expected2 = {:name=>"(2019 UZ)", :diameter=>"51 ft", :miss_distance=>"37755577 miles"}

    assert_equal expected1, @neos_test_date.get_formatted_asteroid_data.first
    assert_equal expected2, @neos_test_date.get_formatted_asteroid_data.last
  end
end
