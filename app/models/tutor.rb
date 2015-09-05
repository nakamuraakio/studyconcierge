class Tutor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subject, dependent: :destroy
  has_many :users
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :subject, allow_destroy: true

  def photo_file= (p)
    if p
      self.photo = p.read
    end
  end
end
