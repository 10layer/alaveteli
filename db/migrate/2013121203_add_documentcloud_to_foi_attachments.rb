class AddDocumentcloudToFoiAttachments < ActiveRecord::Migration
  def up
    add_column :foi_attachments, :documentcloud_id, :string
    add_column :foi_attachments, :documentcloud_url, :string
    add_column :foi_attachments, :documentcloud_sync, :boolean, :default => false
  end

  def down
    remove_column :foi_attachments, :documentcloud_id
    remove_column :foi_attachments, :documentcloud_url
    remove_column :foi_attachments, :documentcloud_public
  end
end

