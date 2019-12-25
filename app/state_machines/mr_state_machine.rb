# Message Request State Machine
class MrStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :purchased
  state :accepted
  state :rejected
  state :cancelled
  state :delivered

  transition from: :pending,   to: [:purchased, :cancelled]
  transition from: :purchased, to: [:accepted, :rejected, :cancelled, :delivered]
  transition from: :accepted,  to: [:cancelled, :delivered]
  transition from: :cancelled, to: [:pending]

  after_transition do |model, transition|
    model.update(status: transition.to_state)
  end
end
