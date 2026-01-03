class AddAdminToStaff < ActiveRecord::Migration[8.0]
  def change
    add_column :staffs, :admin, :boolean
  end
end
