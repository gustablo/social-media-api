module Shareable
  extend ActiveSupport::Concern

  def share(user)
    new_shareable = self.dup
    new_shareable.user = user

    if new_shareable.save
      self.shares_count = shares_count + 1
      save
    end
  end
end
