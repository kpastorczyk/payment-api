class CreatePaymentSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_subscriptions do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :number
      t.string :month
      t.string :year
      t.string :verification_value
      t.boolean :paid

      t.timestamps
    end
  end
end
