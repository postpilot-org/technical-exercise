class InitSchema < ActiveRecord::Migration[4.2]
  def up
    safety_assured do
      # These are extensions that must be enabled in order to support this database
      enable_extension "plpgsql"
      create_table "active_storage_attachments", id: :serial do |t|
        t.string "name", null: false
        t.string "record_type", null: false
        t.bigint "record_id", null: false
        t.bigint "blob_id", null: false
        t.datetime "created_at", null: false
        t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
        t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
      end
      create_table "active_storage_blobs", id: :serial do |t|
        t.string "key", null: false
        t.string "filename", null: false
        t.string "content_type"
        t.text "metadata"
        t.bigint "byte_size", null: false
        t.string "checksum", null: false
        t.datetime "created_at", null: false
        t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
      end

      add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
