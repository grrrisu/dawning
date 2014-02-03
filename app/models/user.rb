class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic

  field :name, type: String
  field :role, type: String
  field :notification, type: Boolean, default: true

  has_many :authentications, dependent: :delete

  authenticates_with_sorcery!do |config|
    config.authentications_class = Authentication
  end

  validates :username, presence: true, uniqueness: true
  validates :email, presence: {on: :create}, email: true
  validates :password, presence: {on: :create}, confirmation: true, length: {minimum: 4, if: :password_present?}
  validate :notification_needs_email

  before_create :set_default_role

  has_gravatar default: :retro

  scope :active, -> { where(activation_state: 'active').excludes(username: 'admin') }

  scope :to_be_notified, -> { active.excludes(notification: false) }

  def notification_needs_email
    unless new_record?
      errors.add :email, "is required to receive notifications" if email.blank? && notification
    end
  end

  def password_present?
    password.present?
  end

  def admin?
    role == 'admin'
  end

private

  def set_default_role
    self.role ||= 'member'
  end
end
