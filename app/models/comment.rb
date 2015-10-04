class Comment < ActiveRecord::Base
  #summaryモデルの導入に伴い関連を削除　belongs_to :report
  belongs_to :tutor
  belongs_to :user
  belongs_to :summary
  validates :content, length: { in: 200..500 }, if: :created_by_tutor?
  validates :content, length: { maximum: 500 }, if: :created_by_user?

  def created_by_tutor?
    !created_by_user
  end

  def created_by_user?
  	created_by_user
  end
end
