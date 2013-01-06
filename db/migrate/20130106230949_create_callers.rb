class CreateCallers < ActiveRecord::Migration
  def change
    create_table :callers do |t|

      t.timestamps
      t.string :number
      t.string :timezone
      t.time :time
      t.string :ampm
    end
  end
end
