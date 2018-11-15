class Vacation < Event
  def range
    (start_date..end_date)
  end
end
