class ChangeContextToContenctMicroposts < ActiveRecord::Migration[5.1]
  def change
    rename_column :microposts, :context, :content
  end
end
