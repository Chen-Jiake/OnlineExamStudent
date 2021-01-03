<template>
  <div>
    <el-card class="box-card" style="font-size: 13px; color: #666; padding: 40px">
      <el-tag type="success" style="width: 100%;">主要功能</el-tag>
      <p>1. 考试中心：参加考试</p>
      <p>2. 历史考试：查看考试成绩以及答题情况</p>
    </el-card>
  </div>
</template>

<script>
export default {
  mounted(){
    this.$http
        .get("auth/auth/verifyQ")
        .then(response => {
          const res = response.data;
          if (res.httpCode === 200) {
            this.$store.commit("setUser", res.data);
            this.$store.commit("setIsLogin", true);
          }
        })
        .catch(error => {
          return;
        });
  }
};
</script>

<style lang='less' scoped>
.el-card {
  margin: 20px;
}
</style>
