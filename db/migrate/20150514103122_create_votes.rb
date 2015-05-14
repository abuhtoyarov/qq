class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :votable_id
      t.string :votable_type
      t.integer :rating
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :votes, :users
  end
end
