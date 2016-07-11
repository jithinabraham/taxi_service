class User < ApplicationRecord
  has_secure_password
  has_many :rides

  enum role: {admin: 0, customer: 1}

  after_initialize :set_default_role, if: :new_record?

  validates :name, presence: true
  validates :email, presence: true,
            format: {with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Invalid format"},
            uniqueness: true


  def set_default_role
    self.role ||= :customer
  end

  def active_rides
    rides.active
  end

end
