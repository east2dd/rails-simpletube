class Admin::CategoriesController < Admin::BaseController
  before_filter :set_category, only: [:edit, :update, :destroy, :edit]
  def index
    @categories = Category.roots
  end

  def edit
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def update
    @category.update(category_params)
    render :edit
  end

  def destroy
    @category.destroy
    flash[:success] = "Deleted a category succcessfully"
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit(:name, :description, :parent_id, :position)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end