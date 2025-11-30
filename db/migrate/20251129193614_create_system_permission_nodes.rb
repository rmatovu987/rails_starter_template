class CreateSystemPermissionNodes < ActiveRecord::Migration[8.0]
  def change
    create_table :permission_nodes, comment: 'Hierarchical nodes representing permissions within a business' do |t|
      t.references :business, null: false, foreign_key: true, comment: 'Reference to the business this permission node belongs to'
      t.references :parent, foreign_key: { to_table: :permission_nodes }, comment: 'Optional reference to a parent permission node for hierarchy'
      t.string :path, comment: 'Materialized path or hierarchy path for tree structure'
      t.boolean :is_model, null: false, default: false, comment: 'Indicates if this node represents a model-level permission'
      t.string :name, null: false, comment: 'Human-readable name of the permission node'
      t.string :unique_id, comment: 'Optional unique identifier within a business'
      t.string :encoded_key, comment: 'Optional encoded key for internal reference'
      t.integer :permission_nodes_count, null: false, default: 0, comment: 'Counter cache for child nodes'

      t.timestamps
    end

    # Unique constraints
    add_index :permission_nodes, %i[business_id name], unique: true, name: 'index_permission_nodes_on_business_and_name'
    add_index :permission_nodes, %i[business_id unique_id],
              unique: true,
              where: 'unique_id IS NOT NULL',
              name: 'index_permission_nodes_on_business_and_unique_id'

    # Suggested additional indices for performance
    add_index :permission_nodes, :path, name: 'index_permission_nodes_on_path'
    add_index :permission_nodes, :is_model, name: 'index_permission_nodes_on_is_model'
    add_index :permission_nodes, :permission_nodes_count, name: 'index_permission_nodes_on_permission_nodes_count'
  end
end
