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

  validates :name, presence: { message: "名前を入力してください" }, length: { maximum: 20, message: "名前は20文字以下で入力して下さい" }, if: :not_first_login?
  validates :school, presence: { message: "学校名を入力してください"}, if: :not_first_login?
  validates :lives_in, presence: { message: "現住地を入力してください"}, if: :not_first_login?
  validates :school_desire, presence: { message: "志望校を入力してください"}, if: :not_first_login?

  def photo_file= (p)
    if p
      self.photo = p.read
    end
  end

  def not_first_login?
    !self.id.nil?
  end
end
