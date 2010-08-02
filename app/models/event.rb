# == Schema Information
# Schema version: 20100330111833
#
# Table name: events
#
#  id              :integer(4)      not null, primary key
#  title           :string(255)
#  start_time       :datetime
#  end_time         :datetime
#  all_day         :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#  description     :text
#  event_series_id :integer(4)
#

class Event < ActiveRecord::Base
  attr_accessor :period, :frequency, :commit_button
  attr_accessible :title, :start_time, :end_time, :all_day, :time_slot_id, :description, :event_series_id, :trainer_ids
  has_many :schedules
  has_many :trainers, :through => :schedules
  belongs_to :time_slot
  belongs_to :event_type
  belongs_to :event_series
  # validations
  validates_presence_of :title
  
  REPEATS = [
              "Does not repeat",
              "Daily"          ,
              "Weekly"         ,
              "Monthly"        ,
              "Yearly"         
  ]
  
  def validate
    if (start_time && end_time && (start_time >= end_time)) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end
  
  def update_events(events, event)
    events.each do |e|
      begin 
        st, et = e.start_time, e.end_time
        e.attributes = event
        if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
          nst = DateTime.parse("#{e.start_time.hour}:#{e.start_time.min}:#{e.start_time.sec}, #{e.start_time.day}-#{st.month}-#{st.year}")
          net = DateTime.parse("#{e.end_time.hour}:#{e.end_time.min}:#{e.end_time.sec}, #{e.end_time.day}-#{et.month}-#{et.year}")
        else
          nst = DateTime.parse("#{e.start_time.hour}:#{e.start_time.min}:#{e.start_time.sec}, #{st.day}-#{st.month}-#{st.year}")
          net = DateTime.parse("#{e.end_time.hour}:#{e.end_time.min}:#{e.end_time.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
        #puts "#{nst}           :::::::::          #{net}"
      rescue
        nst = net = nil
      end
      if nst and net
        #          e.attributes = event
        e.start_time, e.end_time = nst, net
        e.save
      end
    end
    
    event_series.attributes = event
    event_series.save
  end

  def coach_list
    self.trainers.map{|c| c.name}.join(",")
  end

end