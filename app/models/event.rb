class Event < ApplicationRecord
  belongs_to :worker, optional: true
  
  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
end

