class DropTableSubscribe < ActiveRecord::Migration
  def change
    drop_table :subscribes
  end
end
