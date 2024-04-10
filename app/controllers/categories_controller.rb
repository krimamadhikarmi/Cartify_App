class CategoriesController < ApplicationController
    def show
        @category = Category.find(params[:id])
        @products = @category.products
    end
    
  def search
    @query = params[:query]
    @category = Category.find_by(name: @query)
    if @category
      redirect_to category_path(@category)
    else
      flash[:notice] = "Category not found"
      redirect_back fallback_location: root_path
    end
  end
end
