class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subject, dependent: :destroy
  belongs_to :tutor
  has_many :comments, dependent: :destroy
  has_many :user_events, dependent: :destroy
  accepts_nested_attributes_for :subject, allow_destroy: true
  has_many :reports, dependent: :destroy
  has_many :summaries, dependent: :destroy

  validates :name, length: { maximum: 10 }

  def photo_file= (p)
    if p
      self.photo = p.read
    end
  end
end
