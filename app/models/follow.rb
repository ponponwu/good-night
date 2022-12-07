class Follow < ApplicationRecord
  belongs_to :user, optional: true
end
