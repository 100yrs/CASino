class CreateCASinoSchema < ActiveRecord::Migration[4.2]
  def change
    create_table :casino_login_tickets do |t|
      t.string :ticket, :null => false

      t.timestamps
    end
    add_index :casino_login_tickets, :ticket, :unique => true

    create_table :casino_auth_token_tickets do |t|
      t.string :ticket, :null => false

      t.timestamps
    end
    add_index :casino_auth_token_tickets, :ticket, :unique => true

    create_table :casino_login_attempts do |t|
      t.integer :user_id, null: false
      t.boolean :successful, default: false

      t.string  :user_ip
      t.text  :user_agent

      t.timestamps
    end

    create_table :casino_proxy_granting_tickets do |t|
      t.string  :ticket,       :null => false
      t.string  :iou,          :null => false
      t.integer :granter_id,   :null => false
      t.string  :pgt_url,      :null => false
      t.string  :granter_type, :null => false

      t.timestamps
    end
    add_index :casino_proxy_granting_tickets, :ticket, :unique => true
    add_index :casino_proxy_granting_tickets, :iou, :unique => true
    add_index :casino_proxy_granting_tickets, [:granter_type, :granter_id], :name => "index_proxy_granting_tickets_on_granter", :unique => true

    create_table :casino_proxy_tickets do |t|
      t.string  :ticket,                                      :null => false
      t.text  :service,                                     :null => false
      t.boolean :consumed,                 :default => false, :null => false
      t.integer :proxy_granting_ticket_id,                    :null => false

      t.timestamps
    end
    add_index :casino_proxy_tickets, :ticket, :unique => true
    add_index :casino_proxy_tickets, :proxy_granting_ticket_id, name: 'casino_proxy_tickets_on_pgt_id'

    create_table :casino_service_rules do |t|
      t.boolean :enabled, :default => true,  :null => false
      t.integer :order,   :default => 10,    :null => false
      t.string  :name,                       :null => false
      t.string  :url,                        :null => false
      t.boolean :regex,   :default => false, :null => false

      t.timestamps
    end
    add_index :casino_service_rules, :url, :unique => true

    create_table :casino_service_tickets do |t|
      t.string  :ticket,                                      :null => false
      t.text  :service,                                     :null => false
      t.integer :ticket_granting_ticket_id
      t.boolean :consumed,                 :default => false, :null => false
      t.boolean :issued_from_credentials,  :default => false, :null => false

      t.timestamps
    end
    add_index :casino_service_tickets, :ticket, :unique => true
    add_index :casino_service_tickets, :ticket_granting_ticket_id, name: 'casino_service_tickets_on_tgt_id'

    create_table :casino_ticket_granting_tickets do |t|
      t.string  :ticket,                                                :null => false
      t.text  :user_agent
      t.integer :user_id,                                               :null => false
      t.boolean :awaiting_two_factor_authentication, :default => false, :null => false
      t.boolean :long_term,                          :default => false, :null => false
      t.string :user_ip

      t.timestamps
    end
    add_index :casino_ticket_granting_tickets, :ticket, :unique => true

    create_table :casino_two_factor_authenticators do |t|
      t.integer :user_id,                    :null => false
      t.string  :secret,                     :null => false
      t.boolean :active,  :default => false, :null => false

      t.timestamps
    end
    add_index :casino_two_factor_authenticators, :user_id

    create_table :casino_users do |t|
      t.string  :authenticator,   :null => false
      t.string  :username,        :null => false
      t.text    :extra_attributes

      t.timestamps
    end
    add_index :casino_users, [:authenticator, :username], :unique => true
  end
end
