# == Schema Information
#
# Table name: events
#
#  id            :bigint(8)        not null, primary key
#  start_date    :datetime
#  end_date      :datetime
#  html_link     :string(255)
#  status        :string(255)
#  summary       :string(255)
#  creator_name  :string(255)
#  creator_email :string(255)
#  type          :string(255)
#  resource_id   :bigint(8)
#

class Vacation < Event
  def range
    (start_date.to_date..end_date.to_date).to_a
  end
end
