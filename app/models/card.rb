class Card < ActiveRecord::Base
  belongs_to :list
  belongs_to :issue
end
