def consolidate_cart(cart)
  new_cart = {}
  cart.each do |food|
    #cart is an array containing hashes
    food.each do |food_name, food_attribute|
      #food is a hash. food_name = "AVOCADO"  food_attribute = :price
      new_cart[food_name] ||= food_attribute  # a ||= b is same as a || a = b. If 'a' is true, it doesn't check the right hand side
      new_cart[food_name][:count] ||= 0       # if there is a count > 0 then left hand side is true. No need to make the count = 0
      new_cart[food_name][:count] += 1        # increments the count by 1
    end
  end
  new_cart
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    #coupons is an array
    coupon_hash.each do |coupon_keys, coupon_values|
      #coupon_keys = :item, :num, :cost  coupon_values = "AVOCADO", 2, 5.00
      if cart.keys.include?(coupon_values) && coupon_hash[:num] <= cart[coupon_values][:count]
        cart[coupon_values][:count] -= coupon_hash[:num]
        cart[coupon_values + " W/COUPON"] ||= {}
        cart[coupon_values + " W/COUPON"][:price] = coupon_hash[:cost]
        cart[coupon_values + " W/COUPON"][:clearance] = cart[coupon_values][:clearance]
        cart[coupon_values + " W/COUPON"][:count] ||= 0
        cart[coupon_values + " W/COUPON"][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |food_name, food_attribute|
    #cart is a hash
    #food_name = "AVOCADO", "TEMPEH"  food_attribute = :price, :clearance, :count
    if food_attribute[:clearance]   #if true. If false it stays the same
      food_attribute[:price] = (food_attribute[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
    total = 0
    consolidated = consolidate_cart(cart)
    couponed = apply_coupons(consolidated, coupons)
    clearanced = apply_clearance(couponed)
    # It's a hash. clearanced = {
    #   "PEANUTBUTTER" => {:price => 2.40, :clearance => true,  :count => 2},
    #   "KALE"         => {:price => 3.00, :clearance => false, :count => 3}
    #   "SOY MILK"     => {:price => 3.60, :clearance => true,  :count => 1}
    # }

    clearanced.each do |item|
      total += item[1][:price]*item[1][:count]
      # item[1] is the value - {:price => 2.40, :clearance => true, :count => 2}
      # item[0] is key - "PEANUTBUTTER"
    end

    if total > 100
      (total*0.9).round(2)
    else
      total.round(2)
    end
end
