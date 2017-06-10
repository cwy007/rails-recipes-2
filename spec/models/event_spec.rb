# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  friendly_id :string
#  status      :string           default("draft")
#  category_id :integer
#
# Indexes
#
#  index_events_on_category_id  (category_id)
#  index_events_on_friendly_id  (friendly_id) UNIQUE
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
