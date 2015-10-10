class Summary < ActiveRecord::Base
  belongs_to :user
  belongs_to :tutor
  has_and_belongs_to_many :reports
  has_many :comments, dependent: :destroy
end
