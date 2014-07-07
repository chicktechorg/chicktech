class AddTemplateFieldToEvents < ActiveRecord::Migration
  def change
    add_column :events, :template, :boolean, default: false
  end
end
