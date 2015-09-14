class ReportsController < ApplicationController
  before_action :set_report, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]
  before_action do
    if !user_signed_in? && !tutor_signed_in?
      redirect_to root_path
    end
  end

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.where(user_id: current_user.id)
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])
    if @report.user != current_user
      render '404'
    end
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    @user_event = UserEvent.new(status: '勉強内容を記録しました。', user_id: current_user.id, event_type: 1)
    
    respond_to do |format|
      if @report.save
        @user_event.link = "/reports/#{@report.id}"
        @user_event.save
        
        format.html { redirect_to @report, notice: '報告を作成しました。' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:japanese_percentage, :japanese_comment, :old_japanese_percentage, :old_japanese_comment, :old_chinese_percentage, :old_chinese_comment, :english_percentage, :english_comment, :math_percentage, :math_comment, :physics_percentage, :physics_comment, :chemistry_percentage, :chemistry_comment, :biology_percentage, :biology_comment, :geology_percentage, :geology_comment, :world_history_percentage, :world_history_comment, :japanese_history_percentage, :japanese_history_comment, :politics_and_economics_percentage, :politics_and_economics_comment, :modern_society_percentage, :modern_society_comment, :ethics_percentage, :ethics_comment, :geography_percentage, :geography_comment, :average_studytime, :free_comment, :user_id)
    end
end
