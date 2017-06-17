# == Schema Information
#
# Table name: registrations
#
#  id         :integer          not null, primary key
#  status     :string           default("pending")
#  uuid       :string
#  event_id   :integer
#  ticket_id  :integer
#  user_id    :integer
#  name       :string
#  email      :string
#  cellphone  :string
#  website    :string
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_registrations_on_event_id   (event_id)
#  index_registrations_on_ticket_id  (ticket_id)
#  index_registrations_on_user_id    (user_id)
#  index_registrations_on_uuid       (uuid) UNIQUE
#

class Registration < ApplicationRecord

  STATUS = ["pending", "confirmed"]
  validates_inclusion_of :status, :in => STATUS
  validates_presence_of :status, :ticket_id

  belongs_to :event
  belongs_to :ticket                    #新建registration时，ticket一定要存在，不然会报错
  belongs_to :user, :optional => true   # :optional => true 可以获得，新建registration时，即使没有user时，也不会报错, 也能新建成功；

  before_validation :generate_uuid, :on => :create

  attr_accessor :current_step
  validates_presence_of :name, :email, :cellphone, :if => :should_validate_basic_data?
  validates_presence_of :name, :email, :cellphone, :bio, :if => :should_validate_all_data?

  def to_param
    self.uuid
  end

  scope :by_status, ->(s){ where( :status => s )}
  scope :by_ticket, ->(t){ where( :ticket_id => t )}

  protected

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def should_validate_basic_data?
    current_step == 2
  end

  def should_validate_all_data?
    current_step == 3 || status == "confirmed"
  end

end
