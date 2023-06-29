# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :set_card, only: %i[show edit update destroy]
  before_action :search_params, only: %i[new]
  before_action :require_user_permission, only: %i[edit update destroy]
  before_action :authenticate_user!, only: %i[index top]

  # GET /cards or /cards.json
  def index
    @user = current_user
    @cards = Card.where(user_id: @user.id)
    @sorted_cards = Card.sorted_by_color(@user.id) # Show cards sorted by color
    @total_price = @cards.sum(&:total_price) # Calculates the total price of the cards
  end

  # GET /cards/1 or /cards/1.json
  def show; end

  # GET /cards/new
  def new
    @cards = ScryfallService.search(params[:search])
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit; end

  # POST /cards or /cards.json
  def create
    if Card.exists_by_name_and_user?(card_params[:name], current_user.id)
      save_card
    else
      save_card
    end
  end

  # PATCH/PUT /cards/1 or /cards/1.json
  def update
    @card.update(card_params)
    @card.destroy_if_quantity_is_zero
    redirect_to cards_path
  end

  # DELETE /cards/1 or /cards/1.json
  def destroy
    destroy_if_quantity_is_zero
  end

  def top
    @user = current_user
    @cards = Card.where(user_id: @user.id)
  end

  def save_card
    @card = find_or_initialize_card # Finds or initializes a card given its name and the current user
    set_card_attributes
    set_card_price # Set the price of the card using the ScryfallService model
    increment_card_quantity
    flash_notice_and_redirect if @card.save
  end

  private

  def find_or_initialize_card
    Card.find_or_initialize_by(name: card_params[:name], user_id: current_user.id)
  end

  def set_card_attributes
    @card.attributes = card_params
    @card.user = current_user
  end

  def set_card_price
    @card_price = ScryfallService.card_price(card_params[:name]) # Get card price using ScryfallService
    @card.price = @card_price['prices']['eur'] || @card_price['prices']['eur_foil'] # Set the price of the card using either eur or eur_foil
  end

  def increment_card_quantity
    @card.quantity += 1
  end

  def flash_notice_and_redirect
    flash[:notice] = 'Carte ajoutée à votre collection!'
    redirect_to new_card_path
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = Card.find(params[:id])
  end

  def require_user_permission
    return if @card.user.can_modify?(current_user)

    flash[:danger] = "Vous n'avez pas les autorisations pour effectuer cette action"
    redirect_to root_path
  end

  # Only allow a list of trusted parameters through.
  def card_params
    params.require(:card).permit(:printed_name, :name, :user_id, :image_uris, :multiverse_ids, :quantity, :price,
                                 :color_identity)
  end

  # This method allows you to retrieve the search parameters, and to capitalize the first letter of each word
  # It also allows you to display a flash message if the user enters less than 3 characters
  def search_params
    params[:search] = if params[:search].present? && params[:search].length >= 3
                        remove_special_characters
                      elsif params[:search].present? && params[:search].length < 3
                        too_short
                      else
                        random_planeswalker_card
                      end
  end

  def too_short
    flash[:alert] = 'Veuillez renseigner au moins 3 caractères pour la recherche'
    redirect_to new_card_path
  end

  def random_planeswalker_card
    %w[Chandra Nissa Jace Gideon Liliana Ajani Sorin Nicol Tezzeret
       Ugin Karn Garruk Vraska Kaya Tibalt].sample
  end

  # Remove accents from the search parameter
  def remove_special_characters
    [params[:search]].flatten.join.unicode_normalize(:nfkd).chars.reject do |c|
      c =~ /[\u02B0-\u02FF\u0300-\u036F]/
    end.join.capitalize
  end
end
