# frozen_string_literal: true

module Dashboard
  module Code
    class DuplicatesController < ApplicationController
      def create
        render json: ::Code.where(value: params[:codes]).pluck(:value)
      end
    end
  end
end
