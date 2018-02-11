class AddQuestionIdToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :attachments, :question, foreign_key: true
  end
end
