class AddIndexToAttachmentsAttachableId < ActiveRecord::Migration[5.1]
  def change
    add_index :attachments, :attachable_id
  end
end
