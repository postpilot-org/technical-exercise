FactoryBot.define do
  factory :discount do
    name { Forgery::Name.industry }
    kind { "uploaded" }

    trait :with_exported_csv do
      csv_export_started_at { 1.minute.ago }
      csv_export_finished_at { Time.zone.now }
      exported_csv do
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'sample.pdf'))
      end
    end
  end
end
