class CreateUploadedCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :codes do |t|
      t.belongs_to :discount
      t.string :value, null: false
      t.string :status, null: false, default: "available"

      t.timestamps
    end

    add_index :codes, :value, unique: true
    add_index :codes, :status
  end
end
