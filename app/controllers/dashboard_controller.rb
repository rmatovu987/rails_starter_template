class DashboardController < ApplicationController
  def index
  end

  def global_search
    @search_results = PgSearch.multisearch(params[:query])
  end
end
