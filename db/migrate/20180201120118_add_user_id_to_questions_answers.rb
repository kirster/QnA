class AddUserIdToQuestionsAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :user_id, :integer, index: true, null: false
    add_column :answers, :user_id, :integer, index: true, null: false
  end
end
