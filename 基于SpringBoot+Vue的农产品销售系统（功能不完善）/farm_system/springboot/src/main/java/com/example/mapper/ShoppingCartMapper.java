package com.example.mapper;

import com.example.entity.ShoppingCart;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ShoppingCartMapper {
    // 获取购物车列表
    List<ShoppingCart> getCartList(Integer userId);

    /**
     * 根据商品ID查询购物车
     *
     * @param goodsId 商品ID
     * @return 购物车
     */
    @Select("SELECT * FROM shopping_cart WHERE goods_id = #{goodsId} AND user_id = #{userId}")
    ShoppingCart selectByGoodsIdAndUserId(Integer goodsId, Integer userId);

    /**
     * 插入购物车
     *
     * @param newCart 购物车
     */
    @Insert("INSERT INTO shopping_cart (user_id, goods_id, count) VALUES (#{userId}, #{goodsId}, #{num})")
    void insert(ShoppingCart newCart);

    /**
     * 更新购物车
     *
     * @param cart 购物车
     */
    @Update("UPDATE shopping_cart SET count = #{num} WHERE goods_id = #{goodsId} AND user_id = #{userId}")
    void update(ShoppingCart cart);

    /**
     * 删除购物车
     *
     * @param cart 购物车
     */
    @Delete("DELETE FROM shopping_cart WHERE goods_id = #{goodsId} AND user_id = #{userId}")
    void delete(ShoppingCart cart);

    @Delete("DELETE FROM shopping_cart WHERE user_id = #{userId}")
    void clearCartByUserId(Integer userId);
}
