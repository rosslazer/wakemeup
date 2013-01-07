class ChangeTimeToString < ActiveRecord::Migration
  def up
  	
  	change_column :callers, :time, :string

  end

  def down
  end
end
