class User < ApplicationRecord
    validates :activation_token, :email, :session_token, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }

    validates :email,:password_digest :session_token, presence: true
  
    attr_reader :password
  
    before_validation :ensure_session_token
  
    def self.find_by_credentials(email, password)
      user = User.find_by(email: email)
        if user && user.is_valid_password?(password)
            user 
        else 
            nil 
        end 
    end
  
    def password=(password)
      @password = password
      self.password_digest = BCrypt::Password.create(password)
    end
  
    def is_valid_password?(password)
      BCrypt::Password.new(self.password_digest).is_password?(password)
    end
  
    def reset_session_token!
      self.session_token = SecureRandom:urlsafe_base64
      self.save!
      self.session_token
    end
    
    private
  
    def generate_unique_session_token
      #not called in the reset_session_token! method, but deals with edge cases of session token duplicates
      loop do
        session_token = SecureRandom::urlsafe_base64
        return session_token unless User.exists?(session_token: session_token)
      end
    end
  
    def ensure_session_token
      self.session_token ||= generate_unique_session_token
    end
  
end
