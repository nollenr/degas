class WineriesController < ApplicationController
  # GET /wineries
  # GET /wineries.json

  before_filter :signed_in_user

  def index
    @search = Winery.search(params[:q])
      # This was a huge mistake and a mis-comprehension regarding active record.
      # @bottles = @search.result.order(sort_column + " " + sort_direction).joins(:grape, :winery)
      # To see what the query looks like add the following 2 lines
      # @query =   @search.result.order(sort_column + " " + sort_direction).to_sql
      # logger.debug "************************** Index #{@query}"
      @wineries = @search.result.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wineries }
    end
  end

  # GET /wineries/1
  # GET /wineries/1.json
  def show
    @wineries = Winery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @winery }
    end
  end

  # GET /wineries/new
  # GET /wineries/new.json
  def new
    @winery = Winery.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @winery }
    end
  end

  # GET /wineries/1/edit
  def edit
    @winery = Winery.find(params[:id])
  end

  # POST /wineries
  # POST /wineries.json
  def create
    @winery = Winery.new(params[:winery])

    respond_to do |format|
      if @winery.save
        format.html { redirect_to @winery, notice: 'Winery was successfully created.' }
        format.json { render json: @winery, status: :created, location: @winery }
      else
        format.html { render action: "new" }
        format.json { render json: @winery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wineries/1
  # PUT /wineries/1.json
  def update
    @winery = Winery.find(params[:id])

    respond_to do |format|
      if @winery.update_attributes(params[:winery])
        format.html { redirect_to @winery, notice: 'Winery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @winery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wineries/1
  # DELETE /wineries/1.json
  def destroy
    @winery = Winery.find(params[:id])
    @winery.destroy

    respond_to do |format|
      format.html { redirect_to wineries_url }
      format.json { head :no_content }
    end
  end

  def list
    @wineries = Winery.order(:name).where("name ilike ?", "%#{params[:term]}%")
    render json: @wineries.map(&:name)
  end
end
