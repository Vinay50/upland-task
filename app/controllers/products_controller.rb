class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  helper_method :sort_column, :sort_direction

  def index
    if !params[:filter_category].nil?
      @products = Product.where("category like ?", "%#{params[:filter_category]}%").order(sort_column + " " + sort_direction)
    else
      @products = Product.order(sort_column + " " + sort_direction)
    end
  end


  def show
  end

  def new
    @product = Product.new
  end

  def create
  	Product.import(params[:product][:file])
    flash[:notice] = "Products uploaded successfully"
    redirect_to products_path
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def sort_column
    Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

    def products_list
      scope = (Product.all).filter_scope(filters, prefix: :by)
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :category)
    end
end
