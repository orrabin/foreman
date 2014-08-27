class AddShouldContinueToLookupKey < ActiveRecord::Migration
  def up
    add_column :lookup_keys, :continue_looking, :boolean
  end
  def down
    remove_column :lookup_keys, :continue_looking
  end
end
