<template>

  <div class="app-container">

    <el-row :gutter="24">

      <el-col :span="24">
        <el-card style="margin-bottom: 10px">

          距离考试结束还有：<span style="color: #ff0000;">{{ min }}分钟{{ sec }}秒</span>
          <el-button style="float: right; margin-top: -10px" type="primary" icon="el-icon-plus" :loading="loading" @click="handHandExam()">
            {{ handleText }}
          </el-button>

        </el-card>
      </el-col>

      <el-col :span="6" :xs="24" style="margin-bottom: 10px">

        <el-card>

          <p class="card-title">答题卡</p>
          <el-row :gutter="24" class="card-line" style="padding-left: 10px">
            <el-tag type="info">未作答</el-tag>
            <el-tag type="success">已作答</el-tag>
          </el-row>

          <div v-if="testData.radioList!==undefined && testData.radioList.length > 0">
            <p class="card-title">单选题</p>
            <el-row :gutter="24" class="card-line">
              <el-tag v-for="item in testData.radioList" :type="cardItemClass(item.answered, item.questionId)" @click="switchQuestion(item)"> {{ item.sort+1 }}</el-tag>
            </el-row>
          </div>

          <div v-if="testData.multiList!==undefined && testData.multiList.length > 0">
            <p class="card-title">多选题</p>
            <el-row :gutter="24" class="card-line">
              <el-tag v-for="item in testData.multiList" :type="cardItemClass(item.answered, item.questionId)" @click="switchQuestion(item)">{{ item.sort+1 }}</el-tag>
            </el-row>
          </div>

        </el-card>

      </el-col>

      <el-col :span="18" :xs="24">

        <el-card class="qu-content">
          <p v-if="questionData.questionTitle">{{ questionData.sort + 1 }}.{{ questionData.questionTitle }}</p>
          <div v-if="questionData.questionType === 0">
            <el-radio-group v-model="radioValue">
              <el-radio label="A">A. {{ questionData.questionSelectA }} <div style="clear: both" /></el-radio>
              <el-radio label="B">B. {{ questionData.questionSelectB }} <div style="clear: both" /></el-radio>
              <el-radio label="C">C. {{ questionData.questionSelectC }} <div style="clear: both" /></el-radio>
              <el-radio label="D">D. {{ questionData.questionSelectD }} <div style="clear: both" /></el-radio>
            </el-radio-group>
          </div>

          <div v-if="questionData.questionType === 1">

            <el-checkbox-group v-model="multiValue">
              <el-radio label="A">A. {{ questionData.questionSelectA }} <div style="clear: both" /></el-radio>
              <el-radio label="B">B. {{ questionData.questionSelectB }} <div style="clear: both" /></el-radio>
              <el-radio label="C">C. {{ questionData.questionSelectC }} <div style="clear: both" /></el-radio>
              <el-radio label="D">D. {{ questionData.questionSelectD }} <div style="clear: both" /></el-radio>
            </el-checkbox-group>

          </div>

        </el-card>

        <div style="margin-top: 20px">
          <el-button v-if="showPrevious" type="primary" icon="el-icon-back" @click="handPrevious()">
            上一题
          </el-button>

          <el-button v-if="showNext" type="warning" icon="el-icon-right" @click="handNext()">
            下一题
          </el-button>

        </div>

      </el-col>

    </el-row>
  </div>

</template>

<script>
  import { Loading } from 'element-ui'

  export default {
    name: 'ExamProcess',

    data() {
      return {
        showPrevious: false,
        showNext: true,
        loading: false,
        handleText: '交卷',
        pageLoading: false,
        // 试卷ID
        testId: '',
        // 用户ID
        userId: '',
        allItem: [],
        // 当前题目内容
        questionData: {
        },
        // 试卷信息
        testData: {
          testTimesum: 99999,
          radioList: [],
          multiList: [],
        },
        // 单选选定值
        radioValue: '',
        // 多选选定值
        multiValue: [],
        // 已答ID
        answeredIds: [],
        min: '00',
        sec: '00',
        UserQQuestionQueryVo: {
          testId: '',
          userQId: '',
          questionList: [],
        }
      }
    },
    created() {
      const testId = this.$route.params.testId
      if (typeof testId !== 'undefined') {
        this.UserQQuestionQueryVo.testId = testId
        this.testId = testId
        this.fetchData(testId)
      }
    },

    methods: {
      // 倒计时
      countdown() {
        const testTimesum = this.testData.testTimesum

        // 强制交卷
        if (testTimesum < 0) {
          this.doHandler()
          return
        }

        // 时
        const min = parseInt(testTimesum / 60 % 60)
        const sec = parseInt(testTimesum % 60)
        this.min = min > 9 ? min : '0' + min
        this.sec = sec > 9 ? sec : '0' + sec
        const that = this
        this.testData.testTimesum -= 1
        setTimeout(function() {
          that.countdown()
        }, 1000)
      },

      // 答题卡样式
      cardItemClass(answered, questionId) {
        if (questionId === this.questionData.questionId) {
          return 'warning'
        }

        if (answered) {
          return 'success'
        }

        if (!answered) {
          return 'info'
        }
      },

      /**
       * 统计有多少题没答的
       * @returns {number}
       */
      countNotAnswered() {
        let notAnswered = 0

        var item
        for(item of this.allItem){
          if (!item.answered) {
            notAnswered += 1
          }
        }
        return notAnswered
      },

      /**
       * 下一题
       */
      handNext() {
        const index = this.questionData.sort
        this.handSave(this.allItem[index])
        this.fetchquestionData(this.allItem[index + 1])
      },

      /**
       * 上一题
       */
      handPrevious() {
        const index = this.questionData.sort
        this.handSave(this.allItem[index])
        this.fetchquestionData(this.allItem[index - 1])
      },

      /**
       * 切换题目
       */
      switchQuestion(item) {
        const index = this.questionData.sort
        this.handSave(this.allItem[index])
        this.fetchquestionData(item)
      },

      async doHandler() {
        this.handleText = '正在交卷，请等待...'
        this.loading = true

        this.UserQQuestionQueryVo.questionList = []
        this.UserQQuestionQueryVo.questionList.push(this.testData.radioList)
        this.UserQQuestionQueryVo.questionList.push(this.testData.multiList)
        console.log(this.UserQQuestionQueryVo)

        await this.$http
          .post("/test/userQQuestion/commitTest", this.UserQQuestionQueryVo)
          .then(() => {
            this.$message({
              message: '试卷提交成功，即将进入历史考试！',
              type: 'success'
            })

            this.$router.push({name: 'historyExam'})
          })
      },

      // 交卷操作
      handHandExam() {
        const that = this

        // 交卷保存答案
        this.handSave(this.questionData, function() {
          const notAnswered = that.countNotAnswered()

          let msg = '确认要交卷吗？'

          if (notAnswered > 0) {
            msg = '您还有' + notAnswered + '题未作答，确认要交卷吗?'
          }

          that.$confirm(msg, '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            that.doHandler()
          }).catch(() => {
            that.$message({
              type: 'info',
              message: '交卷已取消，您可以继续作答！'
            })
          })
        })
      },

      // 保存答案
      handSave(item, callback) {
        if(item.questionType === 0) {
          if (this.radioValue !== '') {
            item.questionYesanswer = this.radioValue
          }
        } else {
          if(this.multiValue.length > 0){
            item.questionYesanswer = this.multiValue.join("")
          }
        }

        if (item.questionYesanswer.length > 0) {
          // 加入已答列表
          this.questionData.answered = true
        }

        // 最后一个动作，交卷
        if (callback) {
          callback()
        }
      },

      // 试卷详情
      fetchquestionData(item) {
        // 打开
        const loading = Loading.service({
          text: '拼命加载中',
          background: 'rgba(0, 0, 0, 0.7)'
        })

        this.showPrevious = item.questionId !== this.allItem[0].questionId;

        const last = this.allItem.length - 1
        this.showNext = item.questionId !== this.allItem[last].questionId;

        // 获得详情
        this.questionData = item
        this.radioValue = ''
        this.multiValue = []
        if(this.questionData.answered === true) {
          if (this.questionData.questionType === 0) {
            this.radioValue = this.questionData.questionYesanswer
          } else {
            this.multiValue = this.questionData.questionYesanswer.split("")
          }
        }

        // 关闭详情
        loading.close()
      },

      async fetchData(testId) {
        // 用户
        const res = await this.$http.get("auth/auth/verifyQ");
        this.userId = res.data.data.userId;
        this.UserQQuestionQueryVo.userQId = this.userId

        // 试卷
        await this.$http.get(
          "/test/test/findTestById",
          {
            params: {
              testId: testId
            }
          })
          .then(response => {
            this.testData = response.data.data
            this.testData.testTimesum = this.testData.testTimesum * 60
          })

        // 题目
        await this.$http.get(
          "/test/testQuestion/findQuestionsByTestIdAndUserQId",
          {
            params: {
              testId: testId,
              userQId: this.userId
            }
          })
          .then(response => {
            this.testData.radioList = response.data.data[0]
            this.testData.multiList = response.data.data[1]
            for (var item of this.testData.radioList.entries()){
              item[1].sort = item[0]
              item[1].answered = false
              this.allItem.push(item[1])
            }
            for (item of this.testData.multiList.entries()){
              item[1].sort = item[0]
              item[1].answered = false
              this.allItem.push(item[1])
            }
          })

        await this.$http
          .post("test/testUserQ/addTestforUserQ/"+this.testId+"/"+this.userId)

        // 获得第一题内容
        this.questionData = this.testData.radioList[0]
        // 当前选定
        this.fetchquestionData(this.questionData)
        // 倒计时
        this.countdown()
      },
    }
  }
</script>

<style scoped>

  .qu-content div{
    line-height: 30px;
  }

  .el-checkbox-group label,.el-radio-group label{
    width: 100%;
  }

  .card-title{
    background: #eee;
    line-height: 35px;
    text-align: center;
    font-size: 14px;
  }
  .card-line{
    padding-left: 10px
  }
  .card-line span {
    cursor: pointer;
    margin: 2px;
  }

  /deep/
  .el-radio, .el-checkbox{
    padding: 9px 20px 9px 10px;
    border-radius: 4px;
    border: 1px solid #dcdfe6;
    margin-bottom: 10px;
  }

  .is-checked{
    border: #409eff 1px solid;
  }

  .el-radio img, .el-checkbox img{
    max-width: 200px;
    max-height: 200px;
    border: #dcdfe6 1px dotted;
  }

  /deep/
  .el-checkbox__inner {
    display: none;
  }

  /deep/
  .el-radio__inner{
    display: none;
  }

  /deep/
  .el-checkbox__label{
    line-height: 30px;
  }

  /deep/
  .el-radio__label{
    line-height: 30px;
  }

</style>
