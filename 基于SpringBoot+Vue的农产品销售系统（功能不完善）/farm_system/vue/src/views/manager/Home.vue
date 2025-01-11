<template>
  <div>
    <el-row :gutter="20">
      <el-col :span="12">
        <el-card>
          <div style="font-size: 20px; font-weight: bold; margin-bottom: 20px">
            系统公告
          </div>
          <el-timeline style="width: 100%">
            <el-timeline-item
              :timestamp="item.time"
              placement="top"
              v-for="item in data.noticeList"
              :key="item.id"
            >
              <div class="card">
                <h4>{{ item.title }}</h4>
                <p>{{ item.content }}</p>
              </div>
            </el-timeline-item>
          </el-timeline>
        </el-card>
      </el-col>

      <e-col :span="12">
        <el-card>
          <div class="card-header">
            <div
              style="font-size: 20px; font-weight: bold; margin-bottom: 20px"
            >
              热销列表
            </div>
          </div>
          <div>
            <el-table :data="sales_volume" max-height="281">
              <el-table-column
                type="index"
                :index="1"
                label="索引"
                width="180"
              />
              <el-table-column prop="img" label="商品图片" width="100">
                <template #default="scope">
                  <el-image
                    :src="scope.row.img"
                    style="width: 50px; height: 50px"
                  ></el-image>
                </template>
              </el-table-column>
              <el-table-column prop="name" label="商品名称" width="180" />
              <el-table-column prop="salesVolume" label="销量" />
            </el-table>
          </div>
        </el-card>
      </e-col>
    </el-row>

    <!-- 可视化数据 -->
    <div class="view_data" v-if="data.user.role === 'ADMIN'">
      <el-row :gutter="10">
        <!-- 用户数量 -->
        <el-col :span="8">
          <el-card>
            <template #header>
              <div class="card-header">
                <h2>用户数量</h2>
              </div>
            </template>

            <div class="count_number">
              <span>{{ index_data.totalUserCount }} 位用户</span>
            </div>
          </el-card>
        </el-col>

        <el-col :span="8">
          <el-card>
            <template #header>
              <div class="card-header">
                <h2>商品数量</h2>
              </div>
            </template>

            <div class="count_number">
              <span>{{ index_data.totalProductCount }} 件商品</span>
            </div>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <template #header>
              <div class="card-header">
                <h2>待处理订单数量</h2>
              </div>
            </template>

            <div class="count_number">
              <span>{{ index_data.totalOrderCount }} 条待处理</span>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import request from "@/utils/request";

const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  noticeList: [],
});

// 销量数据
const sales_volume = ref([]);

// 首页可视化数据
const index_data = ref([]);

// 获取销量列表
const getSalesList = async () => {
  const res = await request.get("/goods/selectHotGoods");
  sales_volume.value = res.data;
};

// 获取首页数据
const getIndexData = async () => {
  const res = await request.get("/admin/getHomeData");
  console.log(res.data);
  index_data.value = res.data;
};

// 请求后台的公告数据
request.get("/notice/selectAll").then((res) => {
  data.noticeList = res.data;
});

getSalesList();
getIndexData();
</script>

<style scoped>
.chart {
  height: 400px;
}

.view_data {
  margin-top: 20px;
}

.count_number {
  text-align: center;
  font-size: 1.5rem;
  font-weight: 900;
  color: #39BF23;
  line-height: 2;
}
</style>
