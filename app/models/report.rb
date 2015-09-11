class Report < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  delegate :tutor, to: :user
  validates :free_comment, length: { maximum: 500 }

  
  validate :sum_equals_100
  def sum_equals_100
    percentage_array = [japanese_percentage, old_japanese_percentage, old_chinese_percentage, english_percentage, math_percentage, physics_percentage, chemistry_percentage, biology_percentage, geology_percentage, world_history_percentage, japanese_history_percentage, politics_and_economics_percentage, modern_society_percentage, ethics_percentage, geography_percentage]
    if percentage_array.inject(:+) != 100
      errors.add(:base, '%の合計が100になるように入力して下さい')
    end
  end
end
