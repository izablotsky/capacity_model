class AddReferenceBtwResourceAndEvent < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :resource, index: true
  end
end
