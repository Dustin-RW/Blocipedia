class User < ActiveRecord::Base
    # what does this exactly do?  Program demonstrated that it wouldn't
    # recognize password without this, but mine did
    attr_accessor :password

    has_many :wikis

    has_many :collaborators
    has_many :wikis, through: :collaborators

    before_save :encrypt_password

    before_save :set_default_role

    # look this up, validation of password
    validates_confirmation_of :password
    validates_presence_of :password, on: :create

    before_save { self.email = email.downcase }
    validates_presence_of :email
    validates_uniqueness_of :email

    # user roles
    enum role: [:standard, :premium, :admin]


    def self.authenticate(email, password)
        user = find_by_email(email)

        if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
            user
        end
    end

    def encrypt_password
        if password.present?
            self.password_salt = BCrypt::Engine.generate_salt
            self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
        end
    end

    def set_default_role
      self.role ||= :standard
    end


end
