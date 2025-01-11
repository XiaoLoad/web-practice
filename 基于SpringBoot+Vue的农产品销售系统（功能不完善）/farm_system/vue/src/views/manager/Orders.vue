<template>
  <div>
    <div class="card" style="margin-bottom: 5px">
      <el-input v-model="data.orderNo" style="width: 300px; margin-right: 10px" placeholder="请输入订单编号查询"></el-input>
      <el-button type="primary" @click="load">查询</el-button>
      <el-button type="info" style="margin: 0 10px" @click="reset">重置</el-button>
    </div>

    <div class="card" style="margin-bottom: 5px">
      <el-table :data="data.tableData" stripe>
        <el-table-column label="订单编号" prop="orderNo"></el-table-column>
        <el-table-column label="养殖饲料名称" prop="goodsName"></el-table-column>
        <el-table-column label="养殖饲料图片" prop="goodsImg">
          <template #default="scope">
            <el-image style="width: 50px; height: 50px; border-radius: 5px" :src="scope.row.goodsImg"
              :preview-src-list="[scope.row.goodsImg]" preview-teleported></el-image>
          </template>
        </el-table-column>
        <el-table-column label="购买数量" prop="num"></el-table-column>
        <el-table-column label="下单人" prop="userName"></el-table-column>
        <el-table-column label="订单状态" prop="status">
          <template #default="scope">
            <el-tag v-if="scope.row.status === '已取消'" type="danger">已取消</el-tag>
            <el-tag v-if="scope.row.status === '待退款'" type="warning">待退款</el-tag>
            <el-tag v-if="scope.row.status === '待退货'" color="#000" effect="dark">待退货</el-tag>
            <el-tag v-if="scope.row.status === '待支付'" type="warning">待支付</el-tag>
            <el-tag v-if="scope.row.status === '已退款'" type="success">已退款</el-tag>
            <el-tag v-if="scope.row.status === '已退货'" type="success">已退货</el-tag>
            <el-tag v-if="scope.row.status === '待发货'" type="primary">待发货</el-tag>
            <el-tag v-if="scope.row.status === '待收货'" type="primary">待收货</el-tag>
            <el-tag v-if="scope.row.status === '已完成'" type="success">已完成</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="下单时间" prop="time"></el-table-column>
        <el-table-column label="收货地址" prop="address"></el-table-column>
        <el-table-column label="操作" width="300">
          <template #default="scope">
            <el-button v-if="data.user.role === 'USER' && scope.row.status === '待支付'" type="primary"
              @click="openPay(scope.row, '待发货')">支付</el-button>
            <el-button v-if="data.user.role === 'ADMIN' && scope.row.status === '待发货'" type="primary"
              @click="changeStatus(scope.row, '待收货')">发货</el-button>

            <!-- 退款 -->
            <el-button v-if="data.user.role === 'USER' && scope.row.status === '待发货'" @click="refund(scope.row, '待退款')"
              type="info">
              退款
            </el-button>

            <el-button v-if="data.user.role === 'USER' && scope.row.status === '已完成'" @click="refund(scope.row, '待退货')"
              type="info">
              退货
            </el-button>

            <el-button v-if="data.user.role === 'USER' && scope.row.status === '待退款'"
              @click="cancelRefund(scope.row, '待发货')">
              取消退款
            </el-button>

            <el-button v-if="data.user.role === 'USER' && scope.row.status === '待退货'"
              @click="cancelRefund(scope.row, '已完成')">
              取消退货
            </el-button>

            <el-button v-if="data.user.role === 'ADMIN' && scope.row.status === '待退款'"
              @click="changeStatus(scope.row, '已退款')">
              退款
            </el-button>

            <el-button v-if="data.user.role === 'ADMIN' && scope.row.status === '待退货'" color="#000"
              @click="changeStatus(scope.row, '已退货')">
              退货
            </el-button>

            <el-button v-if="data.user.role === 'USER' && scope.row.status === '待收货'" type="success"
              @click="changeStatus(scope.row, '已完成')">收货</el-button>
            <el-button v-if="data.user.role === 'USER' && scope.row.status === '待支付'" type="danger"
              @click="changeStatus(scope.row, '已取消')">取消</el-button>
            <el-button v-if="
              (data.user.role === 'ADMIN' && scope.row.status === '已完成') ||
              scope.row.status === '已取消'
            " type="danger" @click="handleDelete(scope.row.id)">删除</el-button>

            <el-button v-if="scope.row.status !== '已完成'" @click=" openAddressEdit(scope.row)" color="green">
              修改地址
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <div class="card" v-if="data.total">
      <el-pagination @current-change="load" background layout="prev, pager, next" v-model:page-size="data.pageSize"
        v-model:current-page="data.pageNum" :total="data.total" />
    </div>

    <!-- 模拟支付弹窗 -->
    <el-dialog v-model="dialogVisible" title="支付窗口" width="500" :before-close="handleClose">
      <div class="payContainer">
        <el-image style="width: 100px; height: 100px" src="src\assets\imgs\download.png" :fit="fit" />
        <div>
          <p>您当前要购买的产品为"{{ currentGoods.goodsName }}"</p>
          <p>数量：{{ currentGoods.num }}</p>
          <p>下单人：{{ currentGoods.userName }}</p>
        </div>
        <div>当前为模拟支付，点击支付可直接付款，无需扫码。</div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取消支付</el-button>
          <el-button type="primary" @click="pay()"> 支付 </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 修改地址弹窗 -->
    <el-dialog v-model="addressDiaVisible" width="500" title="修改订单地址">
      <el-form ref="addressForm" :rules="rules" :model="orderData">
        <el-form-item lable="收货地址" prop="address">
          <el-input v-model.trim="orderData.address" placeholder="请输入收货地址"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="addressDiaVisible = false">取消</el-button>
          <el-button type="primary" @click="saveAddress()">保存</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import request from "@/utils/request";
import { reactive, ref } from "vue";
import { ElMessageBox, ElMessage } from "element-plus";

const data = reactive({
  user: JSON.parse(localStorage.getItem("system-user") || "{}"),
  pageNum: 1,
  pageSize: 10,
  total: 0,
  formVisible: false,
  form: {},
  tableData: [],
  orderNo: null,
});

// 单个订单
const orderData = ref([])

const dialogVisible = ref(false);

const currentGoods = ref({});

// 收货地址编辑窗开关
const addressDiaVisible = ref(false)

// 分页查询
const load = () => {
  request
    .get("/orders/selectPage", {
      params: {
        pageNum: data.pageNum,
        pageSize: data.pageSize,
        orderNo: data.orderNo,
        userId: data.user.id
      },
    })
    .then((res) => {
      data.tableData = res.data?.list;
      data.total = res.data?.total;
    });
};

// 打开地址编辑框
const openAddressEdit = async (row) => {
  addressDiaVisible.value = true
  // 查询单个地址
  const { data } = await request.get(`/orders/selectById/${row.id}`)
  console.log(data)
  orderData.value = data
}

const addressForm = ref()

const rules = {
  address: [
    {
      required: true,
      message: '地址不可为空',
      trigger: 'blur',
    },
  ]
}

// 保存地址
const saveAddress = async () => {
  await addressForm.value.validate()
  const res = await request.put('/orders/update/address', orderData.value)
  if (res.code === "200") {
    ElMessage.success(res.msg)
    addressDiaVisible.value = false
    load()
  } else {
    ElMessage.warning(res.msg)
  }
  console.log(res)
}

// 操作按钮
const changeStatus = (row, status) => {
  row.status = status;
  request.put("/orders/update", row).then((res) => {
    if (res.code === "200") {
      load();
      ElMessage.success("操作成功");
      data.formVisible = false;
    } else {
      ElMessage.error(res.msg);
    }
  });
};

// 模拟支付
const openPay = (row, status) => {
  dialogVisible.value = true;
  currentGoods.value = row;
  console.log(currentGoods.value);
};

const pay = () => {
  changeStatus(currentGoods.value, "待发货");
  dialogVisible.value = false;
};

// 删除
const handleDelete = (id) => {
  ElMessageBox.confirm("删除后数据无法恢复，您确定删除吗?", "删除确认", {
    type: "warning",
  })
    .then((res) => {
      request.delete("/orders/delete/" + id).then((res) => {
        if (res.code === "200") {
          load();
          ElMessage.success("操作成功");
        } else {
          ElMessage.error(res.msg);
        }
      });
    })
    .catch((err) => { });
};

// 模拟退款
const refund = (row, status) => {
  // 后端返回的日期字符串
  const dateString = row.time;

  // 将日期字符串转换为JavaScript的Date对象
  const parts = dateString.split(/[- :]/);
  const dateObject = new Date(
    parts[0],
    parts[1] - 1,
    parts[2],
    parts[3],
    parts[4],
    parts[5]
  );

  // 获取当前时间
  const currentDate = new Date();

  // 计算时间差（毫秒）
  const timeDiff = currentDate.getTime() - dateObject.getTime();

  // 计算天数
  const daysDiff = Math.floor(timeDiff / (1000 * 60 * 60 * 24));

  // 判断是否超过七天
  if (daysDiff > 7) {
    ElMessageBox.confirm(
      "该订单已过七日，超时订单退货请联系客服。 联系电话：1182182818。",
      {
        type: "warning",
      }
    );
    return;
  }

  ElMessageBox.confirm(
    "您确认要退款吗？确认后将进入退款工单列表，工作人员将于3日之内联系您进行退款。",
    {
      type: "warning",
    }
  ).then((res) => {
    changeStatus(row, status);
  });
};

// 取消退款
const cancelRefund = (row, status) => {
  ElMessageBox.confirm("您确认要取消退款吗？。", {
    type: "warning",
  }).then((res) => {
    changeStatus(row, status);
  });
};

// 重置
const reset = () => {
  data.orderNo = null;
  load();
};

load();
</script>

<style scoped>
.payContainer {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
</style>
