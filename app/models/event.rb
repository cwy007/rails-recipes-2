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

class Event < ApplicationRecord
  belongs_to :category, :optional => true

  validates_presence_of :name, :friendly_id

  validates_uniqueness_of :friendly_id
  validates_format_of :friendly_id, :with => /\A[a-z0-9\-]+\z/

  #  massage attributes before they're validated (by overwriting before_validation)--Active Record Callbacks
  before_validation :generate_friendly_id, :on => :create

  has_many :tickets, :dependent => :destroy
  accepts_nested_attributes_for :tickets, :allow_destroy => true, :reject_if => :all_blank

  def to_param
    # "#{self.id}-#{self.name}"
    self.friendly_id
  end

  STATUS = ["draft", "public", "private"]
  validates_inclusion_of :status, :in => STATUS

  protected

  def generate_friendly_id
    self.friendly_id ||= SecureRandom.uuid
  end

end
