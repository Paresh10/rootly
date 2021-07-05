class AddColumsToIncidentTable < ActiveRecord::Migration[6.1]
  def change
    add_column :incidents, :severity, :string
  end
end
