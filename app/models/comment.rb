class Comment < ActiveRecord::Base
  belongs_to :report
  belongs_to :tutor
  belongs_to :user
end
