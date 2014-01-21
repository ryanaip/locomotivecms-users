require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'content_entry').to_s

Locomotive::ContentEntry.class_eval do
  devise *[
    :database_authenticatable,
    :registerable,
    :recoverable,
    :confirmable,
  ]

  # Can't use devise validatable because it doesn't appropriately scope by content type
  validate do |entry|
    emails = entry.class.where(email: entry.email).to_a
    errors.add(:email, 'must be unique') unless emails.empty? or emails == [entry]
    errors.add(:password, 'is required') if entry.password.blank? and entry.new_record?
    errors.add(:password_confirmation, 'must match password') if entry.password.present? and entry.password_confirmation != entry.password
  end

  ## devise fields (need to be declared since 2.x) ##
  field :remember_created_at,     type: Time
  field :email,                   type: String, default: ''
  field :encrypted_password,      type: String, default: ''
  field :authentication_token,    type: String
  field :reset_password_token,    type: String
  field :reset_password_sent_at,  type: Time
  field :password_salt,           type: String
  field :sign_in_count,           type: Integer, default: 0
  field :current_sign_in_at,      type: Time
  field :last_sign_in_at,         type: Time
  field :current_sign_in_ip,      type: String
  field :last_sign_in_ip,         type: String
  field :confirmed_at,            type: Time
  field :confirmation_token,      type: String
  field :confirmation_sent_at,    type: Time
end
