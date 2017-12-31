class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.timestamp :start
      t.timestamp :end
      t.text :reason
      t.integer :auditId
      t.string :auditor
      t.integer :applyId
      t.integer :status
      t.string :statusShow
      t.integer :hours
      t.string :applyName
      t.string :auditName
      t.integer :vatype
      t.string :typeName
    end
  end
end
