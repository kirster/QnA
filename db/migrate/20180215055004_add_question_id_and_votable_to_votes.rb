class AddQuestionIdAndVotableToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :value, :integer 
    add_belongs_to :votes, :user, foreign_key: true
    add_column :votes, :votable_id, :integer, null: false
    add_column :votes, :votable_type, :string, null: false
    add_index :votes, [:votable_id, :votable_type]
  end
end
