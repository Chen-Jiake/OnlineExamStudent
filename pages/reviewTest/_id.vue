<template>
  <div style="margin: 20px;">
    <el-backtop></el-backtop>
    <el-card class="box-card">
        <el-card class="box-card question" v-for="(question, index) in questions" :key="question.questionId" >
            <div slot="header">
                <span style="">第{{index + 1}}题：</span>
                <span style="">({{question.fkQuestion.questionScore}}分)</span>
                <span><el-tag type="success" size="mini" v-if="question.fkQuestion.questionLevel == 0">简单</el-tag></span>
                <span><el-tag type="warning" size="mini" v-if="question.fkQuestion.questionLevel == 1">中等</el-tag></span>
                <span><el-tag type="danger" size="mini" v-if="question.fkQuestion.questionLevel == 2">高难</el-tag></span>
                <span class="title">{{question.fkQuestion.questionTitle}}</span>
            </div>
            <!-- 单选题 -->
            <div><el-radio v-model="question.userQQuestionUseranswer" label="A" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer == 'A'">选项A：{{question.fkQuestion.questionSelectA}}</el-radio></div>
            <div><el-radio disabled v-model="question.userQQuestionUseranswer" label="A" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer != 'A'">选项A：{{question.fkQuestion.questionSelectA}}</el-radio></div>

            <div><el-radio v-model="question.userQQuestionUseranswer" label="B" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer == 'B'">选项B：{{question.fkQuestion.questionSelectB}}</el-radio></div>
            <div><el-radio disabled v-model="question.userQQuestionUseranswer" label="B" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer != 'B'">选项B：{{question.fkQuestion.questionSelectB}}</el-radio></div>

            <div><el-radio v-model="question.userQQuestionUseranswer" label="C" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer == 'C'">选项C：{{question.fkQuestion.questionSelectC}}</el-radio></div>
            <div><el-radio disabled v-model="question.userQQuestionUseranswer" label="C" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer != 'C'">选项C：{{question.fkQuestion.questionSelectC}}</el-radio></div>

            <div><el-radio v-model="question.userQQuestionUseranswer" label="D" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer == 'D'">选项D：{{question.fkQuestion.questionSelectD}}</el-radio></div>
            <div><el-radio disabled v-model="question.userQQuestionUseranswer" label="D" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer != 'D'">选项D：{{question.fkQuestion.questionSelectD}}</el-radio></div>

            <div style="margin-top: 10px; color: red;font-size: 14px; font-weight: bold;" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer != question.fkQuestion.questionYesanswer">我的答案：{{question.userQQuestionUseranswer}} | 正确答案： {{question.fkQuestion.questionYesanswer}}</div>
            <div style="margin-top: 10px; color: green;font-size: 14px; font-weight: bold;" v-if="question.fkQuestion.questionType == 0 && question.userQQuestionUseranswer == question.fkQuestion.questionYesanswer">我的答案：{{question.userQQuestionUseranswer}} | 正确答案： {{question.fkQuestion.questionYesanswer}}</div>
            <!-- 多选题 -->
            <el-checkbox-group v-model="question.userQQuestionUseranswer">
                <div><el-checkbox label="A" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer.join(',').search('A') != -1">选项A：{{question.fkQuestion.questionSelectA}}</el-checkbox></div>
                <div><el-checkbox disabled label="A" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer.join(',').search('A') == -1">选项A：{{question.fkQuestion.questionSelectA}}</el-checkbox></div>

                <div><el-checkbox label="B" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer.join(',').search('B') != -1">选项B：{{question.fkQuestion.questionSelectB}}</el-checkbox></div>
                <div><el-checkbox disabled label="B" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer.join(',').search('B') == -1">选项B：{{question.fkQuestion.questionSelectB}}</el-checkbox></div>

                <div><el-checkbox label="C" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer.join(',').search('C') != -1">选项B：{{question.fkQuestion.questionSelectC}}</el-checkbox></div>
                <div><el-checkbox disabled label="C" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer.join(',').search('C') == -1">选项B：{{question.fkQuestion.questionSelectC}}</el-checkbox></div>

                <div><el-checkbox label="D" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer.join(',').search('D') != -1">选项B：{{question.fkQuestion.questionSelectD}}</el-checkbox></div>
                <div><el-checkbox disabled label="D" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer.join(',').search('D') == -1">选项B：{{question.fkQuestion.questionSelectD}}</el-checkbox></div>
            </el-checkbox-group>

            <div style="margin-top: 10px; color: green;font-size: 14px; font-weight: bold;" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer == question.fkQuestion.questionYesanswer">我的答案：{{question.userQQuestionUseranswer.join(',')}} | 正确答案： {{question.fkQuestion.questionYesanswer}}</div>
            <div style="margin-top: 10px; color: red;font-size: 14px; font-weight: bold;" v-if="question.fkQuestion.questionType == 1 && question.userQQuestionUseranswer != question.fkQuestion.questionYesanswer">我的答案：{{question.userQQuestionUseranswer.join(',')}} | 正确答案： {{question.fkQuestion.questionYesanswer}}</div>
            <!-- 判断题 -->
            <div><el-radio v-model="question.userQQuestionUseranswer" label="对" v-if="question.fkQuestion.questionType == 2 && question.userQQuestionUseranswer == '对'">对</el-radio></div>
            <div><el-radio disabled v-model="question.userQQuestionUseranswer" label="对" v-if="question.fkQuestion.questionType == 2 && question.userQQuestionUseranswer != '对'">对</el-radio></div>

            <div><el-radio v-model="question.userQQuestionUseranswer" label="错" v-if="question.fkQuestion.questionType == 2 && question.userQQuestionUseranswer == '错'">错</el-radio></div>
            <div><el-radio disabled v-model="question.userQQuestionUseranswer" label="错" v-if="question.fkQuestion.questionType == 2 && question.userQQuestionUseranswer != '错'">错</el-radio></div>

            <div style="margin-top: 10px; color: red;font-size: 14px; font-weight: bold;" v-if="question.fkQuestion.questionType == 2 && question.userQQuestionUseranswer != question.fkQuestion.questionYesanswer">我的答案：{{question.userQQuestionUseranswer}} | 正确答案： {{question.fkQuestion.questionYesanswer}}</div>
            <div style="margin-top: 10px; color: green;font-size: 14px; font-weight: bold;" v-if="question.fkQuestion.questionType == 2 && question.userQQuestionUseranswer == question.fkQuestion.questionYesanswer">我的答案：{{question.userQQuestionUseranswer}} | 正确答案： {{question.fkQuestion.questionYesanswer}}</div>

        </el-card>
    </el-card>


  </div>
</template>

<script>
export default {
  data() {
    return {
      tabPosition: "left",
      testId: this.$route.params.id,
      user: {
        userQId: "",
        userRealname: ""
      },
      questions: []
    };
  },
  mounted() {
    this.$http
        .get("auth/auth/verifyQ")
        .then(response => {
          const res = response.data;
          if (res.httpCode === 200) {
            this.$store.commit("setUser", res.data);
            this.$store.commit("setIsLogin", true);
          }else if (res.httpCode === 401) {
            this.$router.push("/login"); //转到登录页
            return;
          }
        })
        .catch(error => {
          this.$router.push("/login");
          return;
        });

    this.loadQuestions();
  },
  methods: {
    //加载所有试题以及学生答案
    async loadQuestions() {
      //获取当前用户
      const res = await this.$http.get("auth/auth/verifyQ");
      this.user.userQId = res.data.data.userId;
      this.user.userRealname = res.data.data.userRealname;

      const res2 = await this.$http.get(
        "test/userQQuestion/findUserQQuestionByTestIdAndUserQId",
        {
          params: {
            fkTestId: this.testId,
            fkUserQId: this.user.userQId
          }
        }
      );

      this.questions = res2.data.data;

      //处理一下用户的多项选择题所选的答案，将字符串转化为数组
      for(let i = 0; i < this.questions.length; i++){
          if(this.questions[i].fkQuestion.questionType == 1){
              this.questions[i].userQQuestionUseranswer = this.questions[i].userQQuestionUseranswer.split(',')
          }
      }
    }
  }
};
</script>

<style lang='less' scoped>
.question {
  margin: 5px 0px 20px 10px;
}

.title {
  font-weight: bolder;
  font-size: 15px;
}
</style>
