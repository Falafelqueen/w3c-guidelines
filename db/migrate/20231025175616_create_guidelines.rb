class CreateGuidelines < ActiveRecord::Migration[7.0]
  def change
    create_table :guidelines do |t|
  
      t.timestamps
    end
  end
end
