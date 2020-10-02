require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def test_a_date_returns_a_list_of_neos
    results = NearEarthObjects.find_neos_by_date('2019-03-30')
    assert_equal '(2019 GD4)', results[:astroid_list][0][:name]
  end

  def test_get_list_data
    date = '2019-03-30'
    require "pry"; binding.pry

    asteroids_list_data = get_list_data(date)

    assert_equal Faraday::Response, asteroids_list_data.class
  end

  def test_parse_astreroids_data
    date = '2019-03-30'
    asteroids_list_data = get_list_data(date)

    parsed_asteroids_data = parse_asteroids_data(asteroids_list_data, date)

    assert_equal "3840858", parsed_asteroids_data[0][:id]
  end

  def test_get_formatted_asteroid_data
    date = '2019-03-30'
    asteroids_list_data = get_list_data(date)
    parsed_asteroids_data = parse_asteroids_data(asteroids_list_data, date)

    formatted_asteroid_data = get_formatted_asteroid_data(parsed_asteroids_data)

    assert_equal "(2019 GD4)", formatted_asteroid_data[0][:name]
  end

  def test_get_largest_asteroid_diameter
    date = '2019-03-30'
    asteroids_list_data = get_list_data(date)
    parsed_asteroids_data = parse_asteroids_data(asteroids_list_data, date)

    largest_asteroid_diameter = get_largest_asteroid_diameter(parsed_asteroids_data)

    assert_equal 10233, largest_asteroid_diameter
  end
end
