# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Rails Admin - using node_modules version
pin "rails_admin/src/rails_admin/base", to: "rails_admin/src/rails_admin/base.js", preload: false
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js", preload: true
pin "jquery-ui", to: "https://cdn.jsdelivr.net/npm/jquery-ui-dist@1.13.2/jquery-ui.min.js", preload: true
