class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :suggest, foreign_key: true, null: false
      t.string :text, null: false
      t.timestamps
    end
  end
end
