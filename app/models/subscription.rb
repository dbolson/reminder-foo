class Subscription < ActiveRecord::Base
  belongs_to :account
  belongs_to :event_list
  belongs_to :subscriber

  validates :event_list_id,
            :subscriber_id,
            presence: true

  attr_accessible :event_list, :subscriber

  before_validation :validate_owned_by_account

  validates :event_list_id,
            uniqueness: { scope: :subscriber_id }

  def self.create_for_account(params)
    account = params.fetch(:account)
    event_list = params.fetch(:event_list)
    subscriber = params.fetch(:subscriber)

    subscription = account.subscriptions.build
    subscription.event_list = event_list
    subscription.subscriber = subscriber
    subscription.save
    subscription
  end

  private

  def validate_owned_by_account
    if has_all_assocations?
      unless account_owns_associations?
        errors.add(:account, not_owned_error_message)
        false
      end
    end
  end

  def has_all_assocations?
    event_list && subscriber
  end

  def account_owns_associations?
    associated_accounts.all? do |id|
      id == account_id
    end
  end

  def associated_accounts
    [event_list.account_id, subscriber.account_id]
  end

  def not_owned_error_message
    'You can only have subscriptions for your event lists and subscribers'
  end
end
