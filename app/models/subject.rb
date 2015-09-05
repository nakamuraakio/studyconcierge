class Subject < ActiveRecord::Base
  belongs_to :user
  belongs_to :tutor
end
