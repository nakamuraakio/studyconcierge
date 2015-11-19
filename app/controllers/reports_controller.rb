class ReportsController < ApplicationController
  before_action :set_report, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_profile

  before_action do
    if !user_signed_in? && !tutor_signed_in?
      flash[:notice] = 'ログインして下さい'
      redirect_to root_path
    end
  end

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.where(user_id: current_user.id).order('created_at DESC')
    @events = UserEvent.where('user_id = ? AND (event_type = ? OR event_type = ?)', current_user.id, 7, 1).select(:event_type, :link, :created_at)
    
    @summaries = Summary.where(user_id: current_user.id)
    if @reports.count == 0
      flash[:notice] = '記録がありません'
      redirect_to home_index_path
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])
    @yesterday_report = Report.where("created_at <= ? AND created_at >= ? AND user_id = ?", @report.created_at.beginning_of_day, @report.created_at.beginning_of_day - 1.day, current_user.id).first
    @subject_array = Array.new()
    @subject_time = Array.new()
    @yesterday_subject_time = Array.new()
    subject_hash.each do |key, value|
      str = "current_user.subject.#{key}"
      str2 = "@report.#{key}_percentage"
      str3 = "@yesterday_report.#{key}_percentage"
      if eval(str)
        @subject_array.push(value)
        @subject_time.push(eval(str2))
        if @yesterday_report
          @yesterday_subject_time.push(eval(str3))
        end
      end
    end



    #関係ない人のレポートを勝手に見られないようにするコード
    if user_signed_in?
      if @report.user != current_user
        render_404
      end
    elsif tutor_signed_in?
      count = 0
      current_tutor.users.each do |user|
        if @report.user == user
          break
        else
          count += 1
        end
      end
      if count == current_tutor.users.count
        render_404
      end
    else
      render_404
    end
  end

  # GET /reports/new
  def new
    @report = Report.where("created_at >= ? AND user_id = ?", Time.zone.now.beginning_of_day, current_user.id).first
    @report ||= Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    sum = 0
    report_params.each do |key, value|
      if value.to_i != 0
        sum += value.to_i / 60
      end
    end
    
    
    
    report_params_array = report_params.to_a
    str1 = "report_params_array[0][1] = (report_params_array[0][1].to_i / 60).to_s"
    #str2 = "report_params_array[1][1] = @report.#{report_params_array[1][0]} + '\n' + report_params_array[1][1]"
    eval(str1)
    #eval(str2)
    report_params_array[2] = ["average_studytime", "#{sum}"]

    @report = Report.new(Hash[*report_params_array.flatten])
    
    @report.average_studytime = sum

    @report.user_id = current_user.id
    @user_event = UserEvent.new(status: '勉強内容を記録しました。', user_id: current_user.id, event_type: 1)
    
    respond_to do |format|
      if @report.save
        current_user.update(studying_flag: false, studying_subject_attribute: 0, studying_started_at: nil)
        @user_event.link = "/reports/#{@report.id}"
        @user_event.save
        
        format.html { redirect_to @report, notice: '勉強内容を記録しました。' }
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
#    current_user.update(studying_flag: false, studying_subject_attribute: 0, studying_started_at: nil)
    sum = @report.average_studytime
    report_params.each do |key, value|
      if value.to_i != 0
        sum += value.to_i / 60
      end
    end
    report_params["average_studytime"] = "#{sum}"

    @user_event = UserEvent.new(status: '勉強内容を記録しました。', user_id: current_user.id, event_type: 1)
    respond_to do |format|
      if @report.update(report_params)
        @user_event.link = "/reports/#{@report.id}"
        @user_event.save

        format.html { redirect_to @report, notice: '勉強内容を記録しました。' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_via_timer
    @report = Report.find(params[:id])
    report_params_array = report_params.to_a
    #report_params.each_with_index do |(key, value), index|
    #  str[index] = "former_data[#{index}] = @report.#{key}"
    #end

    str1 = "report_params_array[0][1] = (report_params_array[0][1].to_i / 60 + @report.#{report_params_array[0][0]}.to_i).to_s"
    #str2 = "report_params_array[1][1] = @report.#{report_params_array[1][0]} + '\n' + report_params_array[1][1]"

    eval(str1)
    #eval(str2)
    sum = @report.average_studytime
    report_params.each do |key, value|
      if value.to_i != 0
        sum += value.to_i / 60
      end
    end
    report_params_array[2] = ["average_studytime", "#{sum}"]
    
    

    @user_event = UserEvent.new(status: '勉強内容を記録しました。', user_id: current_user.id, event_type: 1)
    respond_to do |format|
      if @report.update(Hash[*report_params_array.flatten])
        current_user.update(studying_flag: false, studying_subject_attribute: 0, studying_started_at: nil)
        @user_event.link = "/reports/#{@report.id}"
        @user_event.save

        format.html { redirect_to @report, notice: '勉強内容を記録しました。' }
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
