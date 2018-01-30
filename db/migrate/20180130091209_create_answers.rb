class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.text :body, null: false
      t.integer :question_id, index: true, null: false

      t.timestamps
    end
  end
end
