class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    @attachment.destroy if current_user.author?(@attachment.attachable)
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
