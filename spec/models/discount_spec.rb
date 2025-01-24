# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discount, type: :model do
  subject(:discount) { described_class.new }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
