class UpdateIncidentTableContent < ActiveRecord::Migration[6.1]
  def change
    remove_columns :incidents, :sev0, :sev1, :sev2
  end
end
