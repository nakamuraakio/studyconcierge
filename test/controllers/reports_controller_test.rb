require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    @report = reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report" do
    assert_difference('Report.count') do
      post :create, report: { average_studytime: @report.average_studytime, biology_comment: @report.biology_comment, biology_percentage: @report.biology_percentage, chemistry_comment: @report.chemistry_comment, chemistry_percentage: @report.chemistry_percentage, english_comment: @report.english_comment, english_percentage: @report.english_percentage, ethics_comment: @report.ethics_comment, ethics_percentage: @report.ethics_percentage, free_comment: @report.free_comment, geography_comment: @report.geography_comment, geography_percentage: @report.geography_percentage, geology_comment: @report.geology_comment, geology_percentage: @report.geology_percentage, japanese_comment: @report.japanese_comment, japanese_history_comment: @report.japanese_history_comment, japanese_history_percentage: @report.japanese_history_percentage, japanese_percentage: @report.japanese_percentage, math_comment: @report.math_comment, math_percentage: @report.math_percentage, modern_society_comment: @report.modern_society_comment, modrn_society_percentage: @report.modrn_society_percentage, old_chinese_comment: @report.old_chinese_comment, old_chinese_percentage: @report.old_chinese_percentage, old_japanese_comment: @report.old_japanese_comment, old_japanese_percentage: @report.old_japanese_percentage, physics_comment: @report.physics_comment, physics_percentage: @report.physics_percentage, politics_and_economics_comment: @report.politics_and_economics_comment, politics_and_economics_percentage: @report.politics_and_economics_percentage, user_id: @report.user_id, world_history_comment: @report.world_history_comment, world_history_percentage: @report.world_history_percentage }
    end

    assert_redirected_to report_path(assigns(:report))
  end

  test "should show report" do
    get :show, id: @report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @report
    assert_response :success
  end

  test "should update report" do
    patch :update, id: @report, report: { average_studytime: @report.average_studytime, biology_comment: @report.biology_comment, biology_percentage: @report.biology_percentage, chemistry_comment: @report.chemistry_comment, chemistry_percentage: @report.chemistry_percentage, english_comment: @report.english_comment, english_percentage: @report.english_percentage, ethics_comment: @report.ethics_comment, ethics_percentage: @report.ethics_percentage, free_comment: @report.free_comment, geography_comment: @report.geography_comment, geography_percentage: @report.geography_percentage, geology_comment: @report.geology_comment, geology_percentage: @report.geology_percentage, japanese_comment: @report.japanese_comment, japanese_history_comment: @report.japanese_history_comment, japanese_history_percentage: @report.japanese_history_percentage, japanese_percentage: @report.japanese_percentage, math_comment: @report.math_comment, math_percentage: @report.math_percentage, modern_society_comment: @report.modern_society_comment, modrn_society_percentage: @report.modrn_society_percentage, old_chinese_comment: @report.old_chinese_comment, old_chinese_percentage: @report.old_chinese_percentage, old_japanese_comment: @report.old_japanese_comment, old_japanese_percentage: @report.old_japanese_percentage, physics_comment: @report.physics_comment, physics_percentage: @report.physics_percentage, politics_and_economics_comment: @report.politics_and_economics_comment, politics_and_economics_percentage: @report.politics_and_economics_percentage, user_id: @report.user_id, world_history_comment: @report.world_history_comment, world_history_percentage: @report.world_history_percentage }
    assert_redirected_to report_path(assigns(:report))
  end

  test "should destroy report" do
    assert_difference('Report.count', -1) do
      delete :destroy, id: @report
    end

    assert_redirected_to reports_path
  end
end
