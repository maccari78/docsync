require "application_system_test_case"

class AdminDashboardsTest < ApplicationSystemTestCase
  setup do
    @admin_dashboard = admin_dashboards(:one)
  end

  test "visiting the index" do
    visit admin_dashboards_url
    assert_selector "h1", text: "Admin dashboards"
  end

  test "should create admin dashboard" do
    visit admin_dashboards_url
    click_on "New admin dashboard"

    fill_in "Content", with: @admin_dashboard.content
    fill_in "Title", with: @admin_dashboard.title
    click_on "Create Admin dashboard"

    assert_text "Admin dashboard was successfully created"
    click_on "Back"
  end

  test "should update Admin dashboard" do
    visit admin_dashboard_url(@admin_dashboard)
    click_on "Edit this admin dashboard", match: :first

    fill_in "Content", with: @admin_dashboard.content
    fill_in "Title", with: @admin_dashboard.title
    click_on "Update Admin dashboard"

    assert_text "Admin dashboard was successfully updated"
    click_on "Back"
  end

  test "should destroy Admin dashboard" do
    visit admin_dashboard_url(@admin_dashboard)
    click_on "Destroy this admin dashboard", match: :first

    assert_text "Admin dashboard was successfully destroyed"
  end
end
