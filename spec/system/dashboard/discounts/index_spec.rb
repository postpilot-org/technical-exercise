# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Viewing disounts', type: :system do
  it 'shows information to create a coupon' do
    visit discounts_path

    expect(page).to have_content 'You have no single-use coupons.'
    expect(page).not_to have_button('Create your first Coupon')
  end

  context 'with a discount' do
    let!(:discount) { create(:discount) }

    it 'shows the number of Available/Total coupon codes' do
      create(:code, discount: discount, status: 'used')
      create(:code, discount: discount, status: 'available')

      visit discounts_path

      expect(page).to have_content "#{discount.codes.available.count} / #{discount.codes.count}"
    end

    it 'exports the codes' do
      visit discounts_path
      new_window = window_opened_by { click_link 'export codes' }
      within_window new_window do
        expect(page).to have_content('Your export is being created in the background')
        expect(page).not_to have_link('Download Codes CSV')

        export = discount.discount_codes_exports.last
        DiscountCodesExportJob.perform_now(export)
        visit current_url
        expect(page).to have_link('Download Codes CSV')
      end
    end
  end
end
