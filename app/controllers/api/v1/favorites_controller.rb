# frozen_string_literal: true

class Api::V1::FavoritesController < ApplicationController
  before_action :set_posting, only: %i[create destroy]

  # GET /favorites
  def index
    @favorited_postings = Favorite.all.map(&:posting)
    render json: @favorited_postings
  end

  # POST /favorites
  def create
    @favorite = Favorite.new(user: @user, posting: @posting)

    if @favorite.save
      render json: @favorite, status: :created
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favorites/1
  def destroy
    Favorite.find_by(posting: @posting).destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_posting
    @posting = params[:id] ? Posting.find(params[:id]) : Posting.find(params[:posting_id])
  end

  # Only allow a trusted parameter "white list" through.
  def favorite_params
    params.fetch(:favorite, {}).permit(:posting_id)
  end
end
