class Schedule < ActiveRecord::Base
  attr_accessible :trainer_id, :meeting_id
  belongs_to :trainer
  belongs_to :meeting
end