package com.example.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.IdUtil;
import com.example.entity.Goods;
import com.example.entity.Orders;
import com.example.entity.User;
import com.example.exception.CustomException;
import com.example.mapper.OrdersMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 业务处理
 **/
@Service
public class OrdersService {

    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private GoodsService goodsService;

    @Autowired
    private UserService userService;

    /**
     * 新增
     */
    @Transactional
    public void add(Orders orders) {
        orders.setId(null);
        orders.setOrderNo(IdUtil.fastSimpleUUID());  // 唯一的订单编号
        orders.setTime(DateUtil.now());
        orders.setStatus("待支付");

        // 判断是否存在该用户
        User user = userService.selectById(orders.getUserId());
        if(user == null) {
            throw new CustomException("用户不存在");
        }


        // 存在用户 判断用户地址是否输入，如果为输入则提示用户输入地址
        if (user.getAddress() == null || user.getAddress().trim().isEmpty()) {
            throw new CustomException("用户收货地址未输入");
        }
        orders.setAddress(user.getAddress());

        // 扣减库存
        Goods goods = goodsService.selectById(orders.getGoodsId());
        if (goods == null) {
            throw new CustomException("商品不存在");
        }
        int store = goods.getStore() - orders.getNum();
        if (store < 0) {
            throw new CustomException("商品库存不足");
        }
        goods.setStore(store);

        // 销量
        goods.setSalesVolume(goods.getSalesVolume() + orders.getNum());

        goodsService.updateById(goods);
        ordersMapper.insert(orders);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        ordersMapper.deleteById(id);
    }

    /**
     * 修改状态
     */
    public void updateById(Orders orders) {
        if ("已取消".equals(orders.getStatus()) || "已退款".equals(orders.getStatus())) { //用户取消订单  要返还库存
            Integer goodsId = orders.getGoodsId();
            Goods goods = goodsService.selectById(goodsId);
            if (goods != null) {
                goods.setStore(goods.getStore() + orders.getNum());
                goodsService.updateById(goods);
            } else {
                throw new CustomException("商品不存在");
            }
        }

        Orders order = ordersMapper.selectById(orders.getId());
        // 判断状态校验
        if(order.getStatus().equals("已退货") || order.getStatus().equals("已退款")) {
            throw new CustomException("状态有误，请刷新状态");
        }



        ordersMapper.updateById(orders);
    }

    /**
     * 根据ID查询
     */
    public Orders selectById(Integer id) {
        return ordersMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Orders> selectAll(Orders orders) {
        return ordersMapper.selectAll(orders);
    }

    /**
     * 分页查询
     */
    public PageInfo<Orders> selectPage(Orders orders, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Orders> list = ordersMapper.selectAll(orders);
        return PageInfo.of(list);
    }


    public int countByStatus() {
        return ordersMapper.countByStatus();
    }
}