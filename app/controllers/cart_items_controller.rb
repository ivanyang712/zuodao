class CartItemsController < ApplicationController
  before_action :find_cart_item, only: [:update, :increase, :decrease, :destroy]
  respond_to :js, only: [:decrease, :increase]

  def update
    @cart_item.update(cart_item_params)
    redirect_to carts_path
  end

  # 增加数量
  def increase
    # 加入购物车的数量不能超过库存数量
    if @cart_item.quantity < @cart_item.product.quantity
      @cart_item.change_quantity!(1)
    end
	end

  # 减少数量
	def decrease
    # 课程数量最少为1件
		if @cart_item.quantity > 1
			@cart_item.change_quantity!(-1)
		end
	end

  def destroy
    @cart_item.destroy
    flash.now[:notice] = "课程 #{@cart_item.product.title} 已从购物车中移除~"
    respond_to do |format|
      format.js { render "carts/delete_item" }
    end
  end

  private

  def find_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
