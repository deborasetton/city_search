class CreateAPIClients < ActiveRecord::Migration[6.0]
  def change
    create_table :api_clients do |t|
      t.string :name
      t.timestamps
    end
  end
end
