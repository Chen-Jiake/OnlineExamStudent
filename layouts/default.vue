<template>
  <div>
    <div class="head">
      <el-menu :default-active="$route.path" class="container" mode="horizontal" router>
        <el-menu-item index="/logo" disabled id="logo">
          <img
            src="@/static/timg.jpeg"
            style="height:45px; width:45px"
            @click="toHome"
            alt="在线考试系统"
          />
        </el-menu-item>
        <el-menu-item index="/">
          <i class="el-icon-discount"></i>在线考试系统
        </el-menu-item>
        <el-menu-item index="/examCenter">
          <i class="el-icon-copy-document"></i>考试中心
        </el-menu-item>
        <el-menu-item index="/historyExam">
          <i class="el-icon-document-copy"></i>历史考试
        </el-menu-item>
        <el-menu-item index="/login" style="float:right;" v-if="$store.state.isLogin == false">登录/注册</el-menu-item>
        <el-menu-item
          style="float:right;"
          index="/login"
          v-if="$store.state.isLogin == true"
          @click="logoutQ"
        >退出登录</el-menu-item>
        <el-menu-item
          disabled
          style="float:right; color:#666;font-weight: bold"
          index
          v-if="$store.state.isLogin == true"
        >您好：{{$store.state.user.userRealname}}</el-menu-item>
      </el-menu>
    </div>
    <div class="container main" ref="main">
      <nuxt />
    </div>

  </div>
</template>

<script>
import Vue from "vue";
import axios from "axios";

import NProgress from "nprogress";
import "nprogress/nprogress.css";

axios.defaults.baseURL = "http://ip:10011/api/"
//axios.defaults.baseURL = "http://localhost:10011/api/";

// 允许携带cookie
axios.defaults.withCredentials = true;

//在request拦截器中展示进度条
axios.interceptors.request.use(
  config => {
    if (config.url !== "test/testUserQ/updateTestUserQ") {
      NProgress.start();
    }
    return config;
  },
  error => {
    // 对请求错误做些什么
    return Promise.reject(error);
  }
);

//在response拦截器中隐藏进度条
axios.interceptors.response.use(
  config => {
    if (config.url !== "test/testUserQ/updateTestUserQ") {
      NProgress.done();
    }
    return config;
  },
  error => {
    // 对请求错误做些什么
    NProgress.done();
    return Promise.reject(error);
  }
);

Vue.prototype.$http = axios;

export default {
  data() {
    return {
      activeIndex: "/",
      clientHeight: ""
    };
  },
  methods: {
    toHome() {
      this.$router.push("/");
    },
    //退出登录
    async logoutQ() {
      const res = await this.$http.delete("auth/auth/logoutQ");
      if (res.data.httpCode === 200) {
        this.$message.error("退出成功！");
        this.$store.commit("setIsLogin", false);
        this.$router.push("/login");
      }
    },
    changeFixed(clientHeight) {
      //动态修改样式
      this.$refs.main.style.minHeight = clientHeight - 190 + "px";
    }
  },
  mounted() {
    this.clientHeight = `${document.documentElement.clientHeight}`;

    //es6写法
    window.onresize = () => {
      return (() => {
        this.clientHeight = `${document.documentElement.clientHeight}`;
      })();
    };

    //一般js写法
    // window.onresize = function temp() {
    //   this.clientHeight = `${document.documentElement.clientHeight}`;
    // };
  },
  watch: {
    clientHeight: function() {
      this.changeFixed(this.clientHeight);
    }
  }
};
</script>

<style lang='less' scoped>
.head {
  border-bottom: 1px #ccc solid;
  box-shadow: 2px 2px 3px #ccc !important;
  background-color: #fff;

  width: 100%;

  // position: fixed;
  // top: 0px;
  // z-index: 9999;
}

.container {
  max-width: 1250px;
  min-width: 1250px;

  margin: 0 auto;
}

// .main {
//   // border: solid red 1px;
// }

.footer {
  text-align: center;
  font-size: 12px;
  font-weight: bold;
  color: #666;
  padding: 8px 0px 20px 0px;

  // border: 1px solid red;
}

.el-menu-item.is-disabled {
  opacity: 1;
}

#logo {
  cursor: pointer;
}
</style>
