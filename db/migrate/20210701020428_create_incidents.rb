class CreateIncidents < ActiveRecord::Migration[6.1]
  def change
    create_table :incidents do |t|
      t.string :title
      t.text :description
      t.string :sev0
      t.string :sev1
      t.string :sev2

      t.timestamps
    end
  end
end
