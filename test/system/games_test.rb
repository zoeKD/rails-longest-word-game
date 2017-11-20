require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit games_url
  #
  #   assert_selector "h1", text: "Game"
  # end
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "Attempt with more than 10 lettres yields a score of 0" do
    visit new_url
    fill_in "word", with: "embezzlement"
    click_on "Play"

    assert_text "Sorry"
  end

  test "Attempt with a non english word yields a score of 0" do
    visit new_url
    fill_in "word", with: "fndgjkf"
    click_on "Play"

    assert_text "Sorry"
  end
end
