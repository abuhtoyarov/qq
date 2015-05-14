class AddIndexVote < ActiveRecord::Migration
  def change
	add_index :votes, [:votable_id, :votable_type]
  end
end
