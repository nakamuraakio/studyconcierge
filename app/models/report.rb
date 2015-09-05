class Report < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  delegate :tutor, to: :user
end
