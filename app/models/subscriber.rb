class Subscriber < ActiveRecord::Base
  belongs_to :account
  has_many :subscriptions
  has_many :event_lists, through: :subscriptions

  attr_accessible :phone_number

  validates :phone_number,
            presence: true,
            uniqueness: true
  validate :formatted_phone_number

  before_save :set_formatted_phone_number

  private

  def formatted_phone_number
    return false if phone_number.nil?

    unless strip_non_numeric =~ /\A\d{10,11}\z/
      if errors.blank?
        errors.add(:phone_number, 'is formatted incorrectly')
      end
    end
  end

  def set_formatted_phone_number
    write_attribute(:phone_number, with_country_code)
  end

  def with_country_code
    if strip_non_numeric =~ /\A\d{10}\z/
      "1#{strip_non_numeric}"
    else
      strip_non_numeric
    end
  end

  def strip_non_numeric
    phone_number.gsub(/[^\d]/, '')
  end
end
