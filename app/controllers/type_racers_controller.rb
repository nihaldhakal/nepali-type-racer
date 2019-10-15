class TypeRacersController < ApplicationController
  access all: [:show, :index], user: {except: [:destroy]}, company_admin: :all

  def index
  end

  def new
  end
end
