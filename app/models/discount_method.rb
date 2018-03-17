# == Schema Information
#
# Table name: discount_methods
#
#  id         :integer          not null, primary key
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DiscountMethod < ApplicationRecord
  has_many :cart_items, foreign_key: "discount_method_code", primary_key: "code"
end
