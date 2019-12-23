module Common
  module DbTransaction
    def call(input)
      response = nil
      ActiveRecord::Base.transaction do
        response = super(input)
        raise ActiveRecord::Rollback if response.failure?
      end

      response
    end
  end
end
