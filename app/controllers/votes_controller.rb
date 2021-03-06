class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    news = News.friendly.find(params[:id])
    if vote = Vote.find_user_for_news(current_user, news)
      return render(nothing: true, status: :ok) if can_update_existing_vote?(vote) && vote.change_vote
    else
      @vote = Vote.new(user: current_user, ip: request.ip, news: news, is_up: vote_value)
      return render nothing: true, status: :created if @vote.save
      errors = @vote.errors.full_messages
    end
    render json: { errors: (errors || [I18n.t('errors.vote.already_vote')]) }, status: :forbidden
  end

  private

  def can_update_existing_vote?(vote)
    (params[:vote] == "up" && vote.down?) || (params[:vote] == "down" && vote.up?)
  end

  def vote_symbol
    params[:vote] == "up" ? :up : params[:vote] == "down" ? :down : nil
  end

  def vote_value
    vote_symbol == :up ? true : vote_symbol == :down ? false : nil
  end
end
