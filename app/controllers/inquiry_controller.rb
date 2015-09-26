class InquiryController < ApplicationController
  def send_mail
    # 入力値のチェック
    @inquiry = Inquiry.new(inquiry_params)    
    respond_to do |format|
      if @inquiry.valid?
      # OK
      #メールを送信
        format.html { redirect_to :back, notice: 'お問い合わせフォームより送信しました' }
      else
      # NG。入力画面を再表示
        format.html { redirect_to :back, notice: 'お問い合わせフォームからの送信に失敗しました' }
      end
    end
  end

  private
    def inquiry_params
      params.require(:inquiry).permit(:name, :email, :message)
    end
end