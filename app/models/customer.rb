class Customer < ApplicationRecord
  validates :first_name, presence: true, format: { with: /\A[a-z\-' ]+\z/i }
  validates :last_name, presence: true, format: { with: /\A[a-z\-' ]+\z/i }
  validates :phone, presence: true
  validates :phone, numericality: { only_integer: true }
  validates :phone, length: { is: 10 }
  validates :email, presence: true, email: true
  
  has_many :orders

  def full_name
    "#{first_name} #{last_name}"
  end

  def string_customer
    "#{full_name} #{phone} #{email}"
  end
end
