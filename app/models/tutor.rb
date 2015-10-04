class Tutor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subject, dependent: :destroy
  has_many :users
  has_many :reports, through: :users
  has_many :tutor_events
  has_many :comments, dependent: :destroy
  has_many :articles
  accepts_nested_attributes_for :subject, allow_destroy: true

  validates :name, length: { maximum: 10 }
  validates :nowadays, length: { minimum: 200, maximum: 500 }
  validates :dream, length: { minimum: 200, maximum: 500 }
  validates :intro, length: { minimum: 200, maximum: 500 }
  validate :under_capacity

  def photo_file= (p)
    if p
      self.photo = p.read
    end
  end

  def under_capacity
    if self.users.any?
      if self.users.count > capacity
        errors.add(:base, '現在指導中の人数が指導可能人数を超えています')
      end
    end
  end
end
