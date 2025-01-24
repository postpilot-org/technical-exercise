# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Code, type: :model do
  subject(:code) { described_class.new }

  it { is_expected.to validate_presence_of(:value) }
end
