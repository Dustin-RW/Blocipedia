class User < ActiveRecord::Base
  # what does this exactly do?  Program demonstrated that it wouldn't
  # recognize password without this, but mine did
  attr_accessor :password

  before_save :encrypt_password

  # look this up
  validates_confirmation_of :password
  # look this up
  validates_presence_of :password, on: :create

  validates_presence_of :email
  validates_uniqueness_of :email


  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
