class CreateCodeSets < ActiveRecord::Migration[7.0]
  def change
    create_table :code_sets do |t|
      t.belongs_to :discount

      t.timestamps
    end
  end
end
