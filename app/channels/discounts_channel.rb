# frozen_string_literal: true

class DiscountsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "discounts:#{params[:discount_id]}"
  end
end
