# frozen_string_literal: true

discount = FactoryBot.create(:discount)
FactoryBot.create_list(:code, 1_000, discount: discount)
