class UserEvent < ActiveRecord::Base
  belongs_to :user

  before_save do
    # タイムラインには30件までしか掲載されないように
    user_event = UserEvent.where(user_id: self.user_id)
    if user_event.count >= 30
      user_event.order('created_at').first.destroy
    end
  end

  def start_time
    self.created_at ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end
end
