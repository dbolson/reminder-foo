class Subscription < ActiveRecord::Base
  belongs_to :account
  belongs_to :event_list
  belongs_to :subscriber

  validates :event_list_id,
            :subscriber_id,
            presence: true
  validates :event_list_id,
            uniqueness: { scope: :subscriber_id }

  before_validation :validate_owned_by_account

  def self.create_for_account(params)
    account = params.fetch(:account)
    event_list_id = params[:subscription].fetch(:event_list_id, nil)
    subscriber_id = params[:subscription].fetch(:subscriber_id, nil)

    subscription = account.subscriptions.build
    subscription.event_list_id = event_list_id
    subscription.subscriber_id = subscriber_id
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
