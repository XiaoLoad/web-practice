<template>
  <div style="padding-bottom: 50px">
    <div class="card" style="margin-bottom: 10px">
      <el-button :class="{ active: data.activeCategoryId === null }" @click="loadCategoryGoods(null)">全部</el-button>
      <el-button :class="{ active: data.activeCategoryId === item.id }" @click="loadCategoryGoods(item.id)"
        v-for="item in data.categoryList" :key="item.id">{{ item.name }}</el-button>
    </div>
    <div style="margin-bottom: 10px">
      <el-input style="width: 300px; margin-right: 5px" v-model="data.name" placeholder="请输入商品名称关键字查询"></el-input>
      <el-button type="primary" @click="load">搜索</el-button>
      <el-button type="info" @click="rest">重置</el-button>
    </div>

    <el-row :gutter="10" v-if="data.total > 0">
      <el-col style="margin-bottom: 10px" :span="6" v-for="item in data.goodsList" :key="item.id">
        <div class="card">
          <img :src="item.img" alt="" style="width: 100%; height: 280px" />
          <div style="font-size: 18px; margin: 5px 0; color: #333">
            {{ item.name }}
          </div>
          <el-tooltip v-if="item.descr.length > 40" :content="item.descr" effect="light" placement="top">
            <div class="line2" style="margin: 5px 0; color: #666; font-size: 14px; height: 40px">
              {{ item.descr }}
            </div>
          </el-tooltip>
          <div v-else class="line2" style="margin: 5px 0; color: #666; font-size: 14px; height: 40px">
            {{ item.descr }}
          </div>
          <div>
            <el-badge :value="item.salesVolume" :max="99999" class="item">
              <el-tag>销量</el-tag>
            </el-badge>
          </div>
          <div style="margin: 5px 0">
            <el-tag type="success">{{ item.specials }}</el-tag>
          </div>
          <div style="
              margin: 10px 0;
              display: flex;
              align-items: center;
              color: #666;
            ">
            <div style="flex: 1">
              <strong style="color: red; font-size: 18px">￥{{ item.price }}</strong>/{{ item.unit }}
            </div>
            <div style="flex: 1; text-align: center">
              库存：{{ item.store }}
            </div>
            <div>
              <el-input-number v-model="item.num" style="width: 120px" :min="0" :max="999"></el-input-number>
            </div>
          </div>
          <!-- <div
            style="
              display: flex;
              align-items: center;
              justify-content: flex-end;
            "
            v-if="item.num > 0"
          >
            总价：<strong
              style="
                margin-right: 5px;
                display: inline-block;
                min-width: 50px;
                font-size: 18px;
                color: red;
              "
              >￥{{ item.total }}</strong
            >
            <el-button type="primary" @click="buy(item)">购买</el-button>
          </div> -->
          <div>
            <el-button v-if="item.num > 0" style="width: 100%; margin-top: 10px" type="primary"
              @click="addShoppingCart(item)">添加至购物车</el-button>
            <el-button style="width: 100%; margin-top: 10px; margin-left: 0" @click="openDetails(item)">查看详情</el-button>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 暂无养殖饲料 -->
    <div style="padding: 50px 0; text-align: center; font-size: 24px; color: #888" v-else>
      暂无养殖饲料...
    </div>

    <div class="card" v-if="data.total">
      <el-pagination @current-change="load" background layout="prev, pager, next" v-model:page-size="data.pageSize"
        v-model:current-page="data.pageNum" :total="data.total" />
    </div>

    <!-- 购物车按钮 -->
    <div v-show="!dialogVisible && !shopping_cart_list" class="shopping_cart">
      <el-badge :value="shopping_cart_data.length" class="item">
        <el-button type="primary" :icon="ShoppingCart" size="large" @click="openShoppingCart" circle></el-button>
      </el-badge>
    </div>

    <!-- 购物车列表 -->
    <el-dialog v-model="shopping_cart_list" title="购物车列表" align-center width="70%" :before-close="handleClose">
      <el-row>
        <el-col :span="24">
          <el-table :data="shopping_cart_data" ref="multipleTableRef" max-height="250"
            @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55" />
            <el-table-column label="图片" width="200">
              <template #default="scope">
                <el-image style="width: 100px; height: 100px" :src="scope.row.goodsImg" :fit="fit" />
              </template>
            </el-table-column>
            <el-table-column prop="goodsName" label="名称" width="200"></el-table-column>
            <el-table-column label="价格">
              <template #default="scope">
                <span style="color: red; font-weight: 800">{{
                  scope.row.price
                }}</span>
                /
                <span>{{ scope.row.unit }}</span>
              </template>
            </el-table-column>
            <el-table-column label="购买数量" width="180">
              <template #default="scope">
                <el-input-number v-model="scope.row.num" style="width: 100px" @change="updateShoppingCart(scope.row)"
                  :min="1" :max="999" size="small"></el-input-number>
              </template>
            </el-table-column>
            <el-table-column label="总计">
              <template #default="scope">
                <span style="color: red; font-weight: 800">￥{{ (scope.row.num * scope.row.price).toFixed(2) }}
                </span>
              </template>
            </el-table-column>
            <el-table-column label="操作">
              <template #default="scope">
                <el-button @click="deleteShoppingCart(scope.row)" type="danger">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-col>
      </el-row>
      <el-row style="margin-top: 20px">
        <el-col :span="24" style="margin-bottom: 10px">
          商品数量：{{ userSelectData.length }} /
          {{ shopping_cart_data.length }}
        </el-col>
        <el-col :span="24">
          总价：<span style="color: red; font-weight: 800; font-size: 1.5rem">¥{{ shopping_cart_total }}</span>
        </el-col>
      </el-row>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="buy" type="primary" :disabled="!userSelectData.length">添加至订单</el-button>
          <el-button @click="clearShoppingCart" type="info" :disabled="!shopping_cart_data.length">清空购物车</el-button>
          <el-button @click="shopping_cart_list = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 商品详情页 -->
    <el-dialog v-model="dialogVisible" title="商品详情" :before-close="handleClose">
      <el-row>
        <el-col :span="10">
          <el-image style="width: 250px; height: 250px" :src="goodsDetails.img" :fit="fit" />
        </el-col>
        <el-col :span="14" class="goods_details_info">
          <h2>{{ goodsDetails.name }}</h2>
          <div>
            <el-scrollbar max-height="100px">
              <p class="goods_details_info_desc">
                <b>介绍：</b>{{ goodsDetails.descr }}
              </p>
            </el-scrollbar>
          </div>
          <p><b>生产商：</b>{{ goodsDetails.manufacturer }}</p>
          <p><b>生产日期：</b>{{ goodsDetails.productionDate }}</p>
          <p><b>保质期：</b>{{ goodsDetails.shelfLife }}</p>
          <div>
            <el-tag class="tag" v-for="tag in goodsDetails.tag" :key="tag">{{
              tag
            }}</el-tag>
          </div>
        </el-col>
      </el-row>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from "vue";
import request from "@/utils/request";
import { ElMessage, ElMessageBox } from "element-plus";
import { ShoppingCart } from "@element-plus/icons-vue";
import { debounce } from "../../utils/debounce";

const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  categoryList: [],
  pageNum: 1,
  pageSize: 10,
  total: 0,
  goodsList: [],
  name: "",
  activeCategoryId: null, // 当前选中的分类ID
});

// 获取用户ID
const user_Id = JSON.parse(localStorage.getItem("system-user")).id;

// 购物车数据
const shopping_cart_data = ref([]);

// 选中购物车数据
const userSelectData = ref([]);
const multipleTableRef = ref();

// 控制商品详情开关
const dialogVisible = ref(false);

// 打开的商品详情
const goodsDetails = ref();

// 打开详情
const openDetails = (item) => {
  dialogVisible.value = true;
  // 处理标签
  const handleTAG = item.specials.split(/[,，]/);
  goodsDetails.value = item;
  goodsDetails.value.tag = handleTAG;
};

// 购物车列表开关
const shopping_cart_list = ref(false);

// 购买
// const buy = () => {
//   request.post("/orders/add", userSelectData.value).then((res) => {
//     if (res.code === "200") {
//       ElMessage.success("添加订单成功");
//       clearShoppingCart();
//       load();
//     } else {
//       ElMessage.error(res.msg);
//     }
//   });
// };

const buy = debounce(
  () => {
    request.post("/orders/add", userSelectData.value).then((res) => {
      if (res.code === "200") {
        ElMessage.success("添加订单成功");
        if (shopping_cart_data.value.length === 0) {
          clearShoppingCart();
        }
        load();
      } else {
        ElMessage.error(res.msg);
      }

      getShoppingCartData()
      load()
    });
  },
  500,
  false
);

// 打开购物车
const handleBuy = (goods) => {
  goods.total = (goods.price * goods.num).toFixed(2); // 计算总价  保留2位小数
  console.log(goods);
  shopping_cart_data.value.push(goods);
};

// 打开购物车
const openShoppingCart = async () => {
  shopping_cart_list.value = true;
  getShoppingCartData();
};

// 获取购物车列表
const getShoppingCartData = async () => {
  // 获取购物车列表
  const res = await request.get(`/shoppingCart/getCartList/${user_Id}`);
  if (res.code === "200") {
    shopping_cart_data.value = res.data;
  }
};

// 添加至购物车
const addShoppingCart = async (item) => {
  console.log(item);
  const newItem = {
    goodsId: item.id,
    num: item.num,
    userId: user_Id,
  };

  console.log(newItem);
  const res = await request.put("/shoppingCart/addCart", newItem);
  if (res.code === "200") {
    ElMessage.success(res.msg);
  } else {
    ElMessage.warning(res.msg);
  }

  getShoppingCartData();
};

// 购物车删除商品
const deleteShoppingCart = async (row) => {
  const newItem = {
    goodsId: row.goodsId,
    userId: user_Id,
  };
  console.log(newItem);

  ElMessageBox.confirm("您确认要删除该商品吗？", {
    type: "warning",
  }).then(async () => {
    const res = await request.delete("/shoppingCart/deleteCart", {
      data: newItem,
    });
    if (res.code === "200") {
      ElMessage.success(res.msg);
      getShoppingCartData();
    }
  });
};

// 更新购物车
const updateShoppingCart = debounce(
  async (item) => {
    const newItem = {
      goodsId: item.goodsId,
      num: item.num,
      userId: user_Id,
    };

    const res = await request.put("/shoppingCart/updateCart", newItem);
    if (res.code === "200") {
      ElMessage.success(res.msg);
    }
  },
  500,
  false
);

// 清空购物车
const clearShoppingCart = async () => {
  const res = await request.delete(`/shoppingCart/clearCart/${user_Id}`);
  if (res.code === "200") {
    ElMessage.success(res.msg);
    getShoppingCartData();
  }
};

// 处理购物车多选
const handleSelectionChange = (val) => {
  userSelectData.value = val;
  console.log(userSelectData.value);
};

// 处理购物车总价
const shopping_cart_total = computed(() => {
  return userSelectData.value
    .reduce((total, item) => {
      return total + item.price * item.num;
    }, 0)
    .toFixed(2);
});

// 获取到分类的数据
request.get("/category/selectAll").then((res) => {
  data.categoryList = res.data;
});

// 分页查询
const load = () => {
  request
    .get("/goods/selectPage", {
      params: {
        pageNum: data.pageNum,
        pageSize: data.pageSize,
        name: data.name,
        categoryId: data.activeCategoryId,
      },
    })
    .then((res) => {
      data.goodsList = res.data?.list;
      data.total = res.data?.total;
      data.goodsList.forEach((item) => {
        item.num = 0;
      });
    });
};

// 重置
const rest = () => {
  data.name = ''
  load()
}

const loadCategoryGoods = (categoryId) => {
  data.activeCategoryId = categoryId;
  load();
};

getShoppingCartData();

load();
</script>

<style scoped>
.active {
  color: white !important;
  background-color: #1967e3 !important;
}

.goods_details_info {
  line-height: 1.5;
}

.goods_details_info p {
  margin: 5px 0;
}

.tag {
  margin-right: 5px;
}

.shopping_cart {
  position: fixed;
  right: 5%;
  bottom: 10%;
  z-index: 99999;
}

.shopping_cart button {
  font-size: 1.5rem;
  width: 50px !important;
  height: 50px;
}
</style>
