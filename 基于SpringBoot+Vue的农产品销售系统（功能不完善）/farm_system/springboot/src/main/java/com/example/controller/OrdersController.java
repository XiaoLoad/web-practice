package com.example.controller;

import com.example.common.Result;
import com.example.entity.Admin;
import com.example.entity.Goods;
import com.example.entity.Orders;
import com.example.service.AdminService;
import com.example.service.GoodsService;
import com.example.service.OrdersService;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 前端操作接口
 **/
@RestController
@RequestMapping("/orders")
public class OrdersController {

    @Resource
    private OrdersService ordersService;

    @Autowired
    private GoodsService goodsService;

    @Autowired
    private AdminService adminService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody List<Orders> orderList) {
        for (Orders order : orderList) {
            ordersService.add(order);
        }
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        ordersService.deleteById(id);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Orders orders) {
        ordersService.updateById(orders);
        return Result.success();
    }

    /**
     * 修改订单地址
     */
    @PutMapping("/update/address")
    public Result updateAdressById(@RequestBody Orders orders) {
        Orders newOrder = ordersService.selectById(orders.getId());
        // 判断订单是否存在
        if(newOrder == null) {
            return Result.error("订单不存在");
        }

        newOrder.setAddress(orders.getAddress());

        ordersService.updateById(newOrder);
        return Result.success("保存成功");
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Orders orders = ordersService.selectById(id);
        return Result.success(orders);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Orders orders) {
        List<Orders> list = ordersService.selectAll(orders);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Orders orders,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        // 判断是否是管理员，如果是管理员，可以查看所有订单，否则只能查看自己的订单
        Admin admin = adminService.selectById(orders.getUserId());
        if (admin != null) {
            orders.setUserId(null);
        }

        PageInfo<Orders> page = ordersService.selectPage(orders, pageNum, pageSize);
        return Result.success(page);
    }

}