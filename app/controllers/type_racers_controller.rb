class TypeRacersController < ApplicationController
  access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all

  def index
    @template = RaceTemplate.all.sample
  end

  def new
  end
end
