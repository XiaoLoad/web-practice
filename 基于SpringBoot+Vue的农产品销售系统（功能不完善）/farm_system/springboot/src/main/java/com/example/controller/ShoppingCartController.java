package com.example.controller;

import com.example.common.Result;
import com.example.entity.Goods;
import com.example.service.GoodsService;
import com.example.service.ShoppingCartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 购物车接口
 */
@RestController
@RequestMapping("/shoppingCart")
public class ShoppingCartController {

    @Autowired
    private ShoppingCartService shoppingCartService;

    @Autowired
    private GoodsService goodsService;

    /**
     * 获取购物车列表
     */
    @GetMapping("/getCartList/{userId}")
    public Result getCart(@PathVariable("userId") Integer userId) {
        return Result.success(shoppingCartService.getCartList(userId));
    }

    /**
     * 添加商品到购物车
     */
    @PutMapping("/addCart")
    public Result addCart(@RequestBody Map<String, Object> requestMap) {
        // 从requestMap中获取goodsId, num, userId
        Integer goodsId = (Integer) requestMap.get("goodsId");
        Integer num = (Integer) requestMap.get("num");
        Integer userId = (Integer) requestMap.get("userId");

        // 判断商品是否存在
        Goods goods = goodsService.selectById(goodsId);
        if (goods == null) {
            return Result.error("商品不存在");
        }

        // 判断用户是否存在
        if (userId == null) {
            return Result.error("用户不存在");
        }

        // 判断商品库存是否充足
        if (num > goods.getStore()) {
            return Result.error("商品库存不足");
        }

        shoppingCartService.addCart(goodsId, num, userId);
        return Result.success("添加成功");
    }

    /**
     * 更新购物车商品数量
     */
    @PutMapping("/updateCart")
    public Result updateCart(@RequestBody Map<String, Object> requestMap) {
        // 从requestMap中获取goodsId, num, userId
        Integer goodsId = (Integer) requestMap.get("goodsId");
        Integer num = (Integer) requestMap.get("num");
        Integer userId = (Integer) requestMap.get("userId");

        // 判断商品是否存在
        Goods goods = goodsService.selectById(goodsId);
        if (goods == null) {
            return Result.error("商品不存在");
        }

        // 判断用户是否存在
        if (userId == null) {
            return Result.error("用户不存在");
        }

        // 判断商品库存是否充足
        if (num > goods.getStore()) {
            return Result.error("商品库存不足");
        }


        shoppingCartService.update(goodsId, num, userId);
        return Result.success("更新成功");
    }

    /**
     * 删除购物车商品
     */
    @DeleteMapping("/deleteCart")
    public Result deleteCart(@RequestBody Map<String, Object> requestMap) {
        // 从requestMap中获取goodsId, userId
        Integer goodsId = (Integer) requestMap.get("goodsId");
        Integer userId = (Integer) requestMap.get("userId");

        // 判断商品是否存在
        Goods goods = goodsService.selectById(goodsId);
        if (goods == null) {
            return Result.error("商品不存在");
        }

        // 判断用户是否存在
        if (userId == null) {
            return Result.error("用户不存在");
        }

        shoppingCartService.delete(goodsId, userId);
        return Result.success("删除成功");
    }

    /**
     * 清空购物车
     */
    @DeleteMapping("/clearCart/{userId}")
    public Result clearCart(@PathVariable("userId") Integer userId) {
        // 判断用户是否存在
        if (userId == null) {
            return Result.error("用户不存在");
        }
        shoppingCartService.clearCart(userId);
        return Result.success("清空成功");
    }
}
