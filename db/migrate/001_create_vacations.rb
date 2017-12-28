class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.timestamp :start
      t.timestamp :end
      t.text :reason
      t.integer :auditId
      t.string :auditor
      t.integer :applyId
      t.string :applier
      t.integer :status
      t.string :statusShow
      t.integer :vahours
    end
  end
end
