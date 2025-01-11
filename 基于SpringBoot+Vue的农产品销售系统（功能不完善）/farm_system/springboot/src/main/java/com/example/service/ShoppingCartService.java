package com.example.service;

import com.example.entity.Goods;
import com.example.entity.ShoppingCart;
import com.example.mapper.ShoppingCartMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ShoppingCartService {

    @Autowired
    private ShoppingCartMapper shoppingCartMapper;

    @Autowired
    private GoodsService goodsService;

    /**
     * 获取购物车中的商品列表
     */
    public List<ShoppingCart> getCartList(Integer userId) {
        return shoppingCartMapper.getCartList(userId);
    }

    /**
     * 添加商品到购物车
     *
     * @param goodsId 商品ID
     * @param num     数量
     * @param userId  用户ID
     */
    public void addCart(Integer goodsId, Integer num, Integer userId) {
        // 判断购物车中是否已经存在该商品
        ShoppingCart cart = shoppingCartMapper.selectByGoodsIdAndUserId(goodsId, userId);
        if (cart == null) {
            // 新增购物车记录
            ShoppingCart newCart = new ShoppingCart();
            newCart.setGoodsId(goodsId);
            newCart.setNum(num);
            newCart.setUserId(userId);
            shoppingCartMapper.insert(newCart);
        } else {
            // 更新购物车记录
            cart.setNum(cart.getNum() + num);
            shoppingCartMapper.update(cart);
        }
    }

    /**
     * 更新购物车记录
     *
     * @param goodsId 商品ID
     * @param num     数量
     * @param userId  用户ID
     */
    public void update(Integer goodsId, Integer num, Integer userId) {
        // 判断购物车中是否存在该商品
        ShoppingCart cart = shoppingCartMapper.selectByGoodsIdAndUserId(goodsId, userId);
        if (cart != null) {
            // 更新购物车记录
            cart.setNum(num);
            shoppingCartMapper.update(cart);
        } else {
            // 没有该商品
            throw new RuntimeException("商品不存在");
        }
    }

    public void delete(Integer goodsId, Integer userId) {
        // 判断购物车中是否存在该商品
        ShoppingCart cart = shoppingCartMapper.selectByGoodsIdAndUserId(goodsId, userId);
        if (cart != null) {
            // 删除购物车记录
            shoppingCartMapper.delete(cart);
        } else {
            // 没有该商品
            throw new RuntimeException("商品不存在");
        }
    }

    public void clearCart(Integer userId) {
        // 删除购物车记录
        shoppingCartMapper.clearCartByUserId(userId);
    }
}
