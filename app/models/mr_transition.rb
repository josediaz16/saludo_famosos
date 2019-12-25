class MrTransition < ApplicationRecord
  belongs_to :message_request, inverse_of: :mr_transitions
  validates :to_state, inclusion: { in: MrStateMachine.states }

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = message_request.mr_transitions.order(:sort_key).last
    return unless last_transition.present?
    last_transition.update_column(:most_recent, true)
  end
end
