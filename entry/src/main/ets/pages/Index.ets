/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the  Eclipse Public License -v 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.eclipse.org/legal/epl-2.0/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  MqttAsync,
  MqttClientOptions,
  MqttConnectOptions,
  MqttSubscribeOptions,
  MqttPublishOptions,
  MqttResponse,
  MqttMessage,
  MqttClient,
  MqttQos,
  MqttPersistenceType
} from '@ohos/mqtt';
import media from '@ohos.multimedia.media';
import LogUtil from './utils/LogUtil';
import TimeUtil from './utils/TimeUtil';

const TAG = 'mqttasync';

@Entry
@Component
struct EmqxPage {
  @State arr: string[] = [];
  private mqttAsyncClient: MqttClient | null = null;
  scroller: Scroller = new Scroller();
  //  Set Client Configuration
  @State topic: string = '';
  @State payload: string = '';
  @State url: string = '10.248.109.55';
  @State clientId: string = 'terminal';
  @State userName: string = "";
  @State password: string = "";
  @State connectedCount: number = 0;
  @State isConnect: boolean = false;
  @State isPromise: boolean = false;

  build() {
    Column({ space: 10 }) {
        Text("鸿蒙智慧工厂控制终端")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .margin(10)
Row({space:20}) {
  Button("创建客户端")
  .onClick(() => {
    this.createClient()
  })


  Button("使用promise接口")
  .onClick(() => {
    this.setIsPromise(this.isPromise)
  })
  Button("读取服务器节点")
    .onClick(()=>{this.payload = "R/NODESTATE";this.publish()})
}

      Row() {
          TextInput({ placeholder: "请输入服务器的URL地址" })
          .onChange((value: string) => this.url = value)
          .width(280)
          .layoutWeight(1)
          Button() {
            Text('连接')
              .fontWeight(FontWeight.Bold)
              .fontColor($r("app.color.white"))
              .maxLines(1)
              .textAlign(TextAlign.Center)
              .width("100%")
          }
          .margin(5)
          .backgroundColor($r("app.color.blue_1677ff"))
          .width(50)
          .onClick(() => {
            this.connect()
          })
        }.width("100%")

Row(){
  TextInput({placeholder:"请输入要订阅的主题"})
    .onChange((value:string)=>this.topic = value)
    .width(280)
    .layoutWeight(1)
  Button() {
    Text('订阅')
      .fontWeight(FontWeight.Bold)
      .fontColor($r("app.color.white"))
      .maxLines(1)
      .textAlign(TextAlign.Center)

  }
  .margin(5)
  .backgroundColor($r("app.color.blue_1677ff"))
  .width(50)
  .onClick(() => {
    this.subscribe()
  })
}
.width("100%")
Row(){
  TextInput({placeholder:"请输入要发送的消息或命令"})
    .onChange((value:string)=>this.payload = value)
    .width(280)
    .layoutWeight(1)
  Button() {
    Text('发送')
      .fontWeight(FontWeight.Bold)
      .fontColor($r("app.color.white"))
      .maxLines(1)
      .textAlign(TextAlign.Center)
  }
  .margin(5)
  .backgroundColor($r("app.color.blue_1677ff"))
  .width(50)
  .onClick(() => {
    this.publish()
  })
}

      Column(){
        Row({space:10}){
          Column({space:10}){
            Text("前轮轮胎")
            Button("启动")
              .onClick(()=>{this.payload="ROB/QLLT/START";this.publish()})
            Button("停止on")
              .onClick(()=>{this.payload="ROB/QLLT/STOP/ON";this.publish()})
            Button("停止off")
              .onClick(()=>{this.payload="ROB/QLLT/STOP/OFF";this.publish()})
            Button("急停")
              .onClick(()=>{this.payload="ROB/QLLT/EMSTOP";this.publish()})
            Button("复位")
              .onClick(()=>{this.payload="ROB/QLLT/HOME";this.publish()})
          }
          Column({space:10}){
            Text("前轮螺栓")
            Button("启动")
              .onClick(()=>{this.payload="ROB/QLLS/START";this.publish()})
            Button("停止on")
              .onClick(()=>{this.payload="ROB/QLLS/STOP/ON";this.publish()})
            Button("停止off")
              .onClick(()=>{this.payload="ROB/QLLS/STOP/OFF";this.publish()})
            Button("急停")
              .onClick(()=>{this.payload="ROB/QLLS/EMSTOP";this.publish()})
            Button("复位")
              .onClick(()=>{this.payload="ROB/QLLS/HOME";this.publish()})
          }
          Column({space:10}){
            Text("前轮螺母")
            Button("启动")
              .onClick(()=>{this.payload="ROB/QLLM/START";this.publish()})
            Button("停止on")
              .onClick(()=>{this.payload="ROB/QLLM/STOP/ON";this.publish()})
            Button("停止off")
              .onClick(()=>{this.payload="ROB/QLLM/STOP/OFF";this.publish()})
            Button("急停")
              .onClick(()=>{this.payload="ROB/QLLM/EMSTOP";this.publish()})
            Button("复位")
              .onClick(()=>{this.payload="ROB/QLLM/HOME";this.publish()})
          }
          Column({space:10}){
            Text("后轮轮胎")
            Button("启动")
              .onClick(()=>{this.payload="ROB/HLLT/START";this.publish()})
            Button("停止on")
              .onClick(()=>{this.payload="ROB/HLLT/STOP/ON";this.publish()})
            Button("停止off")
              .onClick(()=>{this.payload="ROB/HLLT/STOP/OFF";this.publish()})
            Button("急停")
              .onClick(()=>{this.payload="ROB/HLLT/EMSTOP";this.publish()})
            Button("复位")
              .onClick(()=>{this.payload="ROB/HLLT/HOME";this.publish()})
          }
          Column({space:10}){
            Text("后轮螺栓")
            Button("启动")
              .onClick(()=>{this.payload="ROB/HLLS/START";this.publish()})
            Button("停止on")
              .onClick(()=>{this.payload="ROB/HLLS/STOP/ON";this.publish()})
            Button("停止off")
              .onClick(()=>{this.payload="ROB/HLLS/STOP/OFF";this.publish()})
            Button("急停")
              .onClick(()=>{this.payload="ROB/HLLS/EMSTOP";this.publish()})
            Button("复位")
              .onClick(()=>{this.payload="ROB/HLLS/HOME";this.publish()})
          }
          Column({space:10}){
            Text("后轮螺母")
            Button("启动")
              .onClick(()=>{this.payload="ROB/HLLM/START";this.publish()})
            Button("停止on")
              .onClick(()=>{this.payload="ROB/HLLM/STOP/ON";this.publish()})
            Button("停止off")
              .onClick(()=>{this.payload="ROB/HLLM/STOP/OFF";this.publish()})
            Button("急停")
              .onClick(()=>{this.payload="ROB/HLLM/EMSTOP";this.publish()})
            Button("复位")
              .onClick(()=>{this.payload="ROB/HLLM/HOME";this.publish()})
          }
          Column({space:10}){
            Text("座椅安装")
            Button("启动")
              .onClick(()=>{this.payload="ROB/ZYAZ/START";this.publish()})
            Button("停止on")
              .onClick(()=>{this.payload="ROB/ZYAZ/STOP/ON";this.publish()})
            Button("停止off")
              .onClick(()=>{this.payload="ROB/ZYAZ/STOP/OFF";this.publish()})
            Button("急停")
              .onClick(()=>{this.payload="ROB/ZYAZ/EMSTOP";this.publish()})
            Button("复位")
              .onClick(()=>{this.payload="ROB/ZYAZ/HOME";this.publish()})
          }
          Column({space:10}){
            Text("座椅螺丝")
            Button("启动")
              .onClick(()=>{this.payload="ROB/ZYLS/START";this.publish()})
            Button("停止on")
              .onClick(()=>{this.payload="ROB/ZYLS/STOP/ON";this.publish()})
            Button("停止off")
              .onClick(()=>{this.payload="ROB/ZYLS/STOP/OFF";this.publish()})
            Button("急停")
              .onClick(()=>{this.payload="ROB/ZYLS/EMSTOP";this.publish()})
            Button("复位")
              .onClick(()=>{this.payload="ROB/ZYLS/HOME";this.publish()})
          }
          Column({space:10})
          {
            Text("产线开关")
            Button("启动",{type:ButtonType.Circle})
              .onClick(()=>{this.payload="ROB/ALLL/START";this.publish()})
              .size({height:80,width:80})
            Button("停止on",{type:ButtonType.Circle})
              .onClick(()=>{this.payload="ROB/ALLL/STOP/ON";this.publish()})
              .size({height:80,width:80})
            Button("停止off",{type:ButtonType.Circle})
              .onClick(()=>{this.payload="ROB/ALLL/STOP/OFF";this.publish()})
              .size({height:80,width:80})
            Button("复位",{type:ButtonType.Circle})
              .onClick(()=>{this.payload="ROB/ALLL/HOME";this.publish()})
              .size({height:80,width:80})
          }
          .margin({left:20})
        }
      }
        // Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        //   Button() {
        //     Text('MessageArrived')
        //       .fontSize($r("app.float.font_20"))
        //       .fontWeight(FontWeight.Bold)
        //       .fontColor($r("app.color.white"))
        //       .maxLines(1)
        //       .textAlign(TextAlign.Center)
        //   }
        //   .backgroundColor($r("app.color.blue_1677ff"))
        //   .width("100%")
        //   .margin({ right: 8 })
        //   .onClick(() => {
        //     this.messageArrived()
        //   })
        //
        //   Button() {
        //     Text('Unsubscribe')
        //       .fontSize($r("app.float.font_20"))
        //       .fontWeight(FontWeight.Bold)
        //       .fontColor($r("app.color.white"))
        //       .maxLines(1)
        //       .textAlign(TextAlign.Center)
        //   }
        //   .backgroundColor($r("app.color.blue_1677ff"))
        //   .width("100%")
        //   .onClick(() => {
        //     this.unsubscribe()
        //   })
        // }.margin(10)
        //
        // Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        //   Button() {
        //     Text('Disconnect')
        //       .fontSize($r("app.float.font_20"))
        //       .fontWeight(FontWeight.Bold)
        //       .fontColor($r("app.color.white"))
        //       .maxLines(1)
        //       .textAlign(TextAlign.Center)
        //   }
        //   .backgroundColor($r("app.color.blue_1677ff"))
        //   .width("100%")
        //   .margin({ right: 8 })
        //   .onClick(() => {
        //     this.disconnect()
        //   })
        //
        //   Button() {
        //     Text('Destroy')
        //       .fontSize($r("app.float.font_20"))
        //       .fontWeight(FontWeight.Bold)
        //       .fontColor($r("app.color.white"))
        //       .maxLines(1)
        //       .textAlign(TextAlign.Center)
        //   }
        //   .backgroundColor($r("app.color.blue_1677ff"))
        //   .width("100%")
        //   .onClick(() => {
        //     this.destroy()
        //   })
        // }.margin(10)
        //
        // Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        //   Button() {
        //     Text('IsConnected')
        //       .fontSize($r("app.float.font_20"))
        //       .fontWeight(FontWeight.Bold)
        //       .fontColor($r("app.color.white"))
        //       .width("100%")
        //       .maxLines(1)
        //       .textAlign(TextAlign.Center)
        //   }
        //   .backgroundColor($r("app.color.blue_1677ff"))
        //   .width("100%")
        //   .margin({ right: 8 })
        //   .onClick(() => {
        //     if (!this.mqttAsyncClient) {
        //       this.showLog("client is not created");
        //       return;
        //     }
        //     this.isConnected()
        //   })
        //
        //   Button() {
        //     Text('Reconnect')
        //       .fontSize($r("app.float.font_20"))
        //       .fontWeight(FontWeight.Bold)
        //       .fontColor($r("app.color.white"))
        //       .width("100%")
        //       .maxLines(1)
        //       .textAlign(TextAlign.Center)
        //   }
        //   .backgroundColor($r("app.color.blue_1677ff"))
        //   .width("100%")
        //   .onClick(() => {
        //     this.reconnect()
        //   })
        // }.margin(10)
        //
        // Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
        //   Button() {
        //     Text('ConnectLost')
        //       .fontSize($r("app.float.font_20"))
        //       .fontWeight(FontWeight.Bold)
        //       .fontColor($r("app.color.white"))
        //       .width("100%")
        //       .maxLines(1)
        //       .textAlign(TextAlign.Center)
        //   }
        //   .backgroundColor($r("app.color.blue_1677ff"))
        //   .width("100%")
        //   .margin({ right: 8 })
        //   .onClick(() => {
        //     this.connectLost()
        //   })
        //
        //   Button() {
        //     Text('Clear')
        //       .fontSize($r("app.float.font_20"))
        //       .fontWeight(FontWeight.Bold)
        //       .fontColor($r("app.color.white"))
        //       .maxLines(1)
        //       .textAlign(TextAlign.Center)
        //   }
        //   .backgroundColor($r("app.color.blue_1677ff"))
        //   .width("100%")
        //   .onClick(() => {
        //     this.clear()
        //   })
        // }.margin(10)

        Scroll(this.scroller) {
          Column({ space: 8 }) {
            ForEach(this.arr, (item: string) => {//遍历所有存储在arr数组里的字符串并且打印
              Text(item).fontSize($r("app.float.font_18"))
            }, (item: string) => item)
          }
          .alignItems(HorizontalAlign.Start)
          .width("100%")
          .padding(10)
        }
        .width("100%")
        .height("45%")
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .padding(16)
        .align(Alignment.TopStart)



    }
    .margin({bottom:20})
    .backgroundImage($r('app.media.wbg'))
    .backgroundImageSize({width:"100%"})
  }
  showLog(info: string) {
    let time = TimeUtil.currentTimeStamp();//时间格式
    this.arr.push(time + " | " + info);
    this.scroller.scrollEdge(Edge.Bottom);
  }

  createClient(): undefined | void {
    this.showLog("create client");
    if (this.mqttAsyncClient) {
      this.showLog("client is created");
      return;
    }
    this.mqttAsyncClient = MqttAsync.createMqtt({
      url: this.url,
      clientId: this.clientId,
      persistenceType: 1,
    });
    if (!this.mqttAsyncClient) {
      this.showLog("create client failed");
      return;
    }
    this.messageArrived()
    this.connectLost()
    this.mqttAsyncClient.setMqttTrace(6);
    this.showLog("create client success");
  }

  async connect(): Promise<undefined | void> {
    LogUtil.info(TAG, "connect");
    this.showLog("connect");
    let options: MqttConnectOptions = {
      userName: this.userName,
      password: this.password,
      connectTimeout: 300
    };
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    if (!(await this.isConnected())) {
      if (this.isPromise) {
        this.mqttAsyncClient.connect(options).then((data: MqttResponse) => {
          LogUtil.info(TAG, "connect result:" + JSON.stringify(data));
          this.showLog(JSON.stringify(data.message));
          this.connectedCount++;
        }).catch((data: MqttResponse) => {
          LogUtil.info(TAG, "connect fail result:" + JSON.stringify(data));
          this.showLog(JSON.stringify(data.message));
        })
      } else {
        this.mqttAsyncClient.connect(options, (err: Error, data: MqttResponse) => {
          if (!err) {
            LogUtil.info(TAG, "connect result:" + JSON.stringify(data));
            this.showLog(data.message);
            if (data.message == "Connect Success") {
              LogUtil.info(TAG, "connect result connectedCount:");
              this.connectedCount++;
            }
          } else {
            this.showLog("connect error");
            this.showLog(JSON.stringify(err));
            LogUtil.info(TAG, "connect error:" + JSON.stringify(err));
          }
        });
      }
    }
  }

  async publish(): Promise<undefined | void> {
    LogUtil.info(TAG, "publish");
    this.showLog("publish");
    let publishOption: MqttPublishOptions = {
      topic: this.topic,
      qos: 1,
      payload: this.payload
    }
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    if (await this.isConnected()) {
      if (this.isPromise) {
        this.mqttAsyncClient.publish(publishOption).then((data: MqttResponse) => {
          LogUtil.info(TAG, "publish success result:" + JSON.stringify(data));
          this.showLog(data.message);
        }).catch((err: MqttResponse) => {
          LogUtil.info(TAG, "publish fail result:" + JSON.stringify(err));
          this.showLog(err.message);
        })
      } else {
        this.mqttAsyncClient.publish(publishOption, (err: Error, data: MqttResponse) => {
          LogUtil.info(TAG, "publish response:");
          if (!err) {
            this.showLog(data.message);
            LogUtil.info(TAG, "publish result:" + JSON.stringify(data));
          } else {
            this.showLog("publish error");
            this.showLog(JSON.stringify(err));
            LogUtil.info(TAG, "publish error:" + JSON.stringify(err));
          }
        });
      }
    }
  }

  async subscribe(): Promise<undefined | void> {
    LogUtil.info(TAG, "subscribe");
    this.showLog("subscribe");
    let subscribeOption: MqttSubscribeOptions = {
      topic: this.topic,
      qos: 2
    }
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    if (await this.isConnected()) {
      if (this.isPromise) {
        this.mqttAsyncClient.subscribe(subscribeOption).then((data: MqttResponse) => {
          LogUtil.info(TAG, "subscribe success result:" + JSON.stringify(data));
          this.showLog(data.message);
        }).catch((err: MqttResponse) => {
          LogUtil.info(TAG, "subscribe fail result:" + JSON.stringify(err));
          this.showLog(err.message);
        })
      } else {
        this.mqttAsyncClient.subscribe(subscribeOption, (err: Error, data: MqttResponse) => {
          if (!err) {
            this.showLog(data.message);
            LogUtil.info(TAG, "subscribe result:" + JSON.stringify(data));
          } else {
            this.showLog("subscribe error");
            this.showLog(JSON.stringify(err));
            LogUtil.info(TAG, "subscribe error:" + JSON.stringify(err));
          }
        });
      }
    }
  }

  messageArrived(): undefined | void {
    LogUtil.info(TAG, "messageArrived");
    this.showLog("messageArrived");
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    this.mqttAsyncClient.messageArrived((err: Error, data: MqttMessage) => {
      if (!err) {
        let msg = "messageArrived topic:" + data.topic + ", msg:" + data.payload;
        this.showLog(msg);
        LogUtil.info(TAG, "messageArrived message:" + JSON.stringify(data));
      } else {
        this.showLog("messageArrived error");
        this.showLog(JSON.stringify(err));
        LogUtil.info(TAG, "messageArrived error:" + JSON.stringify(err));
      }
    });
  }

  async unsubscribe(): Promise<undefined | void> {
    LogUtil.info(TAG, "unsubscribe");
    this.showLog("unsubscribe");
    let subscribeOption: MqttSubscribeOptions = {
      topic: this.topic,
      qos: 2
    }
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    if (await this.isConnected()) {
      if (this.isPromise) {
        this.mqttAsyncClient.unsubscribe(subscribeOption).then((data: MqttResponse) => {
          LogUtil.info(TAG, "unsubscribe success result:" + JSON.stringify(data));
          this.showLog(data.message);
        }).catch((err: MqttResponse) => {
          LogUtil.info(TAG, "unsubscribe fail result:" + JSON.stringify(err));
          this.showLog(err.message);
        })
      } else {
        this.mqttAsyncClient.unsubscribe(subscribeOption, (err: Error, data: MqttResponse) => {
          if (!err) {
            this.showLog(data.message);
            LogUtil.info(TAG, "unsubscribe result:" + JSON.stringify(data));
          } else {
            this.showLog("unsubscribe error");
            this.showLog(JSON.stringify(err));
            LogUtil.info(TAG, "unsubscribe error:" + JSON.stringify(err));
          }
        });
      }
    }
  }

  async disconnect(): Promise<undefined | void> {
    LogUtil.info(TAG, "disconnect");
    this.showLog("disconnect");
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    if (await this.isConnected()) {
      if (this.isPromise) {
        this.mqttAsyncClient.disconnect().then((data: MqttResponse) => {
          LogUtil.info(TAG, "disconnect success result:" + JSON.stringify(data));
          this.showLog(data.message);
        }).catch((err: MqttResponse) => {
          LogUtil.info(TAG, "disconnect fail result:" + JSON.stringify(err));
          this.showLog(err.message);
        })
      } else {
        this.mqttAsyncClient.disconnect((err: Error, data: MqttResponse) => {
          if (!err) {
            this.showLog(data.message);
            LogUtil.info(TAG, "disconnect result:" + JSON.stringify(data));
          } else {
            this.showLog("disconnect error");
            this.showLog(JSON.stringify(err));
            LogUtil.info(TAG, "disconnect error:" + JSON.stringify(err));
          }
        });
      }
    }
  }

  async isConnected(): Promise<undefined | boolean> {
    LogUtil.info(TAG, "isConnected");
    this.showLog("isConnected");
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    return this.mqttAsyncClient.isConnected().then((data: boolean) => {
      this.showLog("isConnected " + data);
      LogUtil.info(TAG, "isConnected result:" + data);
      if (!data) {
        this.showLog("client not connect");
      }
      return data;
    })
  }

  async reconnect(): Promise<undefined | void> {
    LogUtil.info(TAG, "reconnect");
    this.showLog("reconnect");
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    if (!(await this.isConnected())) {
      if (this.connectedCount == 0) {
        this.showLog("reconnect: client previously not connected");
        LogUtil.info(TAG, "reconnect: client previously not connected");
        return;
      }
      this.mqttAsyncClient.reconnect().then((data: boolean) => {
        this.showLog("reConnected " + data);
        LogUtil.info(TAG, "reConnected result:" + data);
      });
    }
  }

  connectLost(): undefined | void {
    LogUtil.info(TAG, "connectLost");
    this.showLog("connectLost");
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    this.mqttAsyncClient.connectLost((err: Error, data: MqttResponse) => {
      if (!err) {
        this.showLog(data.message);
        this.reconnect();
        LogUtil.info(TAG, "connect lost cause:" + JSON.stringify(data));
      } else {
        this.showLog("connect lost error");
        this.showLog(JSON.stringify(err));
        LogUtil.info(TAG, "connect lost error:" + JSON.stringify(err));
      }
    });
  }

  async destroy(): Promise<undefined | void> {
    LogUtil.info(TAG, "destroy");
    this.showLog("destroy client");
    if (this.mqttAsyncClient == null) {
      this.showLog("client not created");
      return;
    }
    this.mqttAsyncClient.destroy().then((data: boolean) => {
      this.showLog("destroy " + data);
      LogUtil.info(TAG, "destroy result:" + data);
      this.mqttAsyncClient = null;
      this.connectedCount = 0;
    });
  }

  clear(): void {
    this.arr = [];
  }

  setIsPromise(isPromise: boolean): void {
    this.isPromise = !isPromise
    this.showLog("setIsPromise： " + this.isPromise);
    LogUtil.info(TAG, "setIsPromise result:" + this.isPromise);
  }
}