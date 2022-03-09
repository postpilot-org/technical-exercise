# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "dayjs", to: "https://ga.jspm.io/npm:dayjs@1.10.7/dayjs.min.js"
pin "papaparse", to: "https://ga.jspm.io/npm:papaparse@5.3.1/papaparse.min.js"
pin "flatfile-csv-importer", to: "https://ga.jspm.io/npm:flatfile-csv-importer@0.2.6/build/browser/index.js"
pin "pikaday", to: "https://ga.jspm.io/npm:pikaday@1.8.2/pikaday.js"
pin "moment", to: "https://ga.jspm.io/npm:moment@2.29.1/moment.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.2-2/lib/assets/compiled/rails-ujs.js"
pin "@rails/actioncable", to: "https://ga.jspm.io/npm:@rails/actioncable@7.0.2-2/app/assets/javascripts/actioncable.esm.js"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.2-2/app/assets/javascripts/activestorage.esm.js"
pin_all_from "app/javascript/controllers", under: "controllers"
