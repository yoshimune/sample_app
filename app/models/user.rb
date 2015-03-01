class User < ActiveRecord::Base
  before_create :create_remember_token
  
  # name
  validates(:name, presence: true, length: { maximum: 50 })
  
  # email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false })    
  before_save { self.email = email.downcase }
  
  # password
  has_secure_password
  validates(:password, length: { minimum: 6 })
  
  # user_token
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
