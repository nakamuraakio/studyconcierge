class Report < ActiveRecord::Base
  belongs_to :user
  #summaryモデルの導入に伴い関連を削除　has_many :comments, dependent: :destroy
  has_and_belongs_to_many :summaries
  delegate :tutor, to: :user
  validates :japanese_comment, length: { maximum: 140 }
  validates :old_japanese_comment, length: { maximum: 140 }
  validates :old_chinese_comment, length: { maximum: 140 }
  validates :english_comment, length: { maximum: 140 }
  validates :math_comment, length: { maximum: 140 }
  validates :physics_comment, length: { maximum: 140 }
  validates :chemistry_comment, length: { maximum: 140 }
  validates :biology_comment, length: { maximum: 140 }
  validates :geology_comment, length: { maximum: 140 }
  validates :world_history_comment, length: { maximum: 140 }
  validates :japanese_history_comment, length: { maximum: 140 }
  validates :politics_and_economics_comment, length: { maximum: 140 }
  validates :modern_society_comment, length: { maximum: 140 }
  validates :ethics_comment, length: { maximum: 140 }
  validates :geography_comment, length: { maximum: 140 }
  validates :free_comment, length: { maximum: 500 }
  validates_presence_of :japanese_percentage, :old_japanese_percentage, :old_chinese_percentage, :english_percentage, :math_percentage, :physics_percentage, :chemistry_percentage, :biology_percentage, :geology_percentage, :world_history_percentage, :japanese_history_percentage, :politics_and_economics_percentage, :modern_society_percentage, :ethics_percentage, :geography_percentage, {:message => '空欄の「時間」が存在します。'}

  
  #validate :sum_equals_100
  def sum_equals_100
    percentage_array = [japanese_percentage, old_japanese_percentage, old_chinese_percentage, english_percentage, math_percentage, physics_percentage, chemistry_percentage, biology_percentage, geology_percentage, world_history_percentage, japanese_history_percentage, politics_and_economics_percentage, modern_society_percentage, ethics_percentage, geography_percentage]
    if percentage_array.inject(:+) != 100
      errors.add(:base, '%の合計が100になるように入力して下さい')
    end
  end

  
end
