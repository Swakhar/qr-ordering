RailsAdmin.config do |config|
  config.asset_source = :importmap

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :staff
  end
  config.current_user_method(&:current_staff)

  ## Authorization - only allow admin staff
  config.authorize_with do
    redirect_to main_app.root_path, alert: 'Access denied.' unless current_staff&.admin?
  end

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  # Model-specific configurations
  config.model 'Restaurant' do
    list do
      field :name
      field :slug
      field :currency
      field :vat_rate
      field :created_at
    end
  end

  config.model 'Table' do
    list do
      field :restaurant
      field :label
      field :code
      field :created_at
    end
  end

  config.model 'MenuCategory' do
    list do
      field :restaurant
      field :name
      field :position
      field :menu_items
    end
  end

  config.model 'MenuItem' do
    list do
      field :menu_category
      field :name
      field :price_cents
      field :is_active
      field :allergens
    end
    edit do
      field :menu_category
      field :name
      field :description, :text
      field :price_cents
      field :allergens
      field :image_url
      field :is_active
      field :upsell_targets
    end
  end

  config.model 'Order' do
    list do
      field :id
      field :restaurant
      field :table
      field :status
      field :total_cents
      field :paid_cents
      field :created_at
    end
  end

  config.model 'Staff' do
    list do
      field :email
      field :admin
      field :created_at
    end
  end
end
