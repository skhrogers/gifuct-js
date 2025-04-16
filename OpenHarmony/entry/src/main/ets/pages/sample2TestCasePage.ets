/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { GIFComponent, ResourceLoader } from '@ohos/gif-drawable'
import fs from '@ohos.file.fs';
import { resourceManager } from '@kit.LocalizationKit';

@Entry
@Component
struct sample1TestCasePage {
  resourceManager: resourceManager.ResourceManager = getContext(this).resourceManager;
  @State model: GIFComponent.ControllerOptions = new GIFComponent.ControllerOptions();
  @State gifAutoPlay: boolean = true;
  @State gifReset: boolean = false;
  @State loopHint: string = this.resourceManager.getStringByNameSync('data_show_content').toString();
  @State parseHint: string = this.resourceManager.getStringByNameSync('data_parse_state').toString();
  private speedFactor: number = 1
  private scaleType: GIFComponent.ScaleType = GIFComponent.ScaleType.FIT_CENTER
  @State compWidth: number = 300
  @State  compHeight: number = 300
  private gifLoopCount = 0


  canClick1:boolean = true;
  canClick2:boolean = true;
  canClick3:boolean = true;

  build() {
    Scroll() {
      Column() {
        Text($r("app.string.router_alternative"))
          .fontSize(30)
          .margin({bottom: 10, top: 10})
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text($r("app.string.text_play_speed"))
          Button("0.5X")
            .onClick(() => {
              this.speedFactor = 0.5
            }).margin({ left: 3 })

          Button("1X")
            .onClick(() => {
              this.speedFactor = 1
            }).margin({ left: 3 })
          Button("2X")
            .onClick(() => {
              this.speedFactor = 2
            }).margin({ left: 3 })

          Button("3X")
            .onClick(() => {
              this.speedFactor = 3
            }).margin({ left: 3 })
        }.width('100%')
        .margin({bottom:5})

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text("ScaleType")

          Button("FIT_START")
            .fontSize(12)
            .onClick(() => {
              this.scaleType = GIFComponent.ScaleType.FIT_START
            }).margin({ left: 3 })

          Button("FIT_CENTER")
            .fontSize(12)
            .onClick(() => {
              this.scaleType = GIFComponent.ScaleType.FIT_CENTER
            }).margin({ left: 3 })

          Button("FIT_END")
            .fontSize(12)
            .onClick(() => {
              this.scaleType = GIFComponent.ScaleType.FIT_END
            }).margin({ left: 3 })


        }.width('100%')
        .margin({bottom:5})

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Button("CENTER")
            .fontSize(12)
            .onClick(() => {
              this.scaleType = GIFComponent.ScaleType.CENTER
            }).margin({ left: 3 })
          Button("CENTER_CROP")
            .fontSize(12)
            .onClick(() => {
              this.scaleType = GIFComponent.ScaleType.CENTER_CROP
            }).margin({ left: 3 })



        }.width('100%')
        .margin({bottom:5})

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {


          Button("FIT_XY")
            .fontSize(12)
            .onClick(() => {
              this.scaleType = GIFComponent.ScaleType.FIT_XY
            }).margin({ left: 3 })

          Button("CENTER_INSIDE")
            .fontSize(12)
            .onClick(() => {
              this.scaleType = GIFComponent.ScaleType.CENTER_INSIDE
            }).margin({ left: 3 })

        }.width('100%')
        .margin({bottom:5})

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text($r("app.string.text_setting_size"))

          TextArea({ placeholder: $r("app.string.placeholder_width") })

            .placeholderColor("rgb(0,0,35)")
            .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Italic })
            .textAlign(TextAlign.Center)
            .caretColor(Color.Blue)
            .height(40)
            .width(144)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontFamily("sans-serif")
            .fontStyle(FontStyle.Normal)
            .fontColor(Color.Red)
            .onChange((value: string) => {
              this.compWidth = Number(value);

            })
          TextArea({ placeholder: $r("app.string.placeholder_height") })
            .placeholderColor("rgb(0,0,180)")
            .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Italic })
            .textAlign(TextAlign.Center)
            .caretColor(Color.Blue)
            .height(40)
            .width(145)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontFamily("sans-serif")
            .fontStyle(FontStyle.Normal)
            .fontColor(Color.Red)
            .onChange((value: string) => {
              this.compHeight = Number(value);
            })

        }.width('100%')
        .margin({bottom:5})

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text($r("app.string.text_show_text"))
          Text(this.loopHint)
          Text(this.parseHint)
        }.width('100%')
        .height(40).backgroundColor(Color.Pink).margin({bottom:5})


        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text($r("app.string.text_load_source"))
          Button($r("app.string.button_resource"))
            .onClick(() => {
            if(this.canClick1){
              this.canClick1 = false;
              this.gifLoopCount = 0
              this.gifAutoPlay = false;
              this.model.destroy();
              let s1 = new Date().getTime();
              let modelx = new GIFComponent.ControllerOptions()
              modelx
                .setLoopFinish((loopTime) => {
                  this.gifLoopCount++;
                  this.loopHint = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gifLoopCount + " " +
                  this.resourceManager.getStringByNameSync('data_time').toString() +", " +
                  this.resourceManager.getStringByNameSync('data_time_consuming').toString() + " " + loopTime + 'ms';
                })

                .setScaleType(this.scaleType)
                .setSpeedFactor(this.speedFactor)
                .setOpenHardware(false)


              this.parseHint = this.resourceManager.getStringByNameSync('data_parsing').toString();
              ResourceLoader.loadMedia($r('app.media.gifSample').id, getContext(this)).then((buffer) => {
                modelx.loadBuffer(buffer, (error) => {
                  if (error) {
                    console.log('loadMediaByWorker error =' + error)
                  }
                  let e1 = new Date().getTime();
                  this.parseHint = this.resourceManager.getStringByNameSync('data_parse_finish').toString() + (e1 - s1) + 'ms';
                  console.log('loadMedia parsing successfully callback drawing');
                  this.model = modelx
                  this.canClick1 = true
                  this.gifAutoPlay = true
                })
              })
            }


          }).margin({ left: 3 })

          Button($r("app.string.button_local_path"))
            .onClick(() => {
              if(this.canClick2){
                this.canClick2 = false
                getContext(this)['resourceManager'].getMediaContent($r('app.media.gifSample').id)
                  .then(data => {
                    let path = getContext(this)['filesDir'] + '/testGif.gif'
                    this.createFile(path);
                    this.writeNewFileAsync(path, this.typedArrayToBuffer(data)).then(() => {
                      this.gifAutoPlay = false;
                      this.model.destroy();
                      let s2 = new Date().getTime();
                      let modelx = new GIFComponent.ControllerOptions()
                      modelx
                        .setLoopFinish((loopTime) => {
                          this.gifLoopCount++;
                          this.loopHint = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gifLoopCount + " " +
                          this.resourceManager.getStringByNameSync('data_time').toString() +", " +
                          this.resourceManager.getStringByNameSync('data_time_consuming').toString() + " " + loopTime + 'ms';
                        })

                        .setScaleType(this.scaleType)
                        .setSpeedFactor(this.speedFactor)
                        .setOpenHardware(false)

                      this.parseHint = this.resourceManager.getStringByNameSync('data_parsing').toString();
                      ResourceLoader.loadString(path).then((buffer) => {
                        modelx.loadBuffer(buffer, () => {
                          let e2 = new Date().getTime();
                          this.parseHint = this.resourceManager.getStringByNameSync('data_parse_finish').toString() + " " + (e2 - s2) + 'ms';
                          console.log('LoadString parsing successfully callback drawing');
                          this.model = modelx;
                          this.canClick2 = true;
                          this.gifAutoPlay = true;
                        })
                      })
                    })
                  })
                  .catch((err:string) => {
                    console.log('parse gif err=' + err)
                  })
              }

            }).margin({ left: 3 })

          Button($r("app.string.button_network"))
            .onClick(() => {
              if(this.canClick3){
                this.canClick3 = false


                this.gifAutoPlay = false;
                this.model.destroy();
                let s3 = new Date().getTime();
                let modelx = new GIFComponent.ControllerOptions()
                modelx
                  .setLoopFinish((loopTime) => {
                    this.gifLoopCount++;
                    this.loopHint = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gifLoopCount + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString() +", " +
                    this.resourceManager.getStringByNameSync('data_time_consuming').toString() + " " + loopTime + 'ms';
                  })

                  .setScaleType(this.scaleType)
                  .setSpeedFactor(this.speedFactor)
                  .setOpenHardware(false)



                this.parseHint = this.resourceManager.getStringByNameSync('data_parsing').toString();


                ResourceLoader.downloadDataWithContext(getContext(this), {
                  url: 'https://pic.ibaotu.com/gif/18/17/16/51u888piCtqj.gif!fwpaa70/fw/700'
                }, (sucBuffer:ArrayBuffer) => {
                  modelx.loadBuffer(sucBuffer, (err) => {
                    if (err) {
                      console.log(err)
                      return
                    }
                    let e3 = new Date().getTime();
                    this.parseHint = this.resourceManager.getStringByNameSync('data_parse_finish').toString() + " " + (e3 - s3) + 'ms';
                    console.log('The network loading and parsing is successful and the callback is drawn!');
                    this.model = modelx;
                    this.canClick3 = true
                    this.gifAutoPlay = true;
                  })
                }, () => {
                })
              }
            }).margin({ left: 3 })


        }.width('100%')
        .height(40).backgroundColor(Color.Pink).margin({bottom:5})


        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text($r("app.string.text_control"))
          Button($r("app.string.button_start"))
            .onClick(() => {
              this.gifAutoPlay = true;
            }).margin({ left: 3 })

          Button($r("app.string.button_pause"))
            .onClick(() => {
              this.gifAutoPlay = false;
            }).margin({ left: 3 })

          Button($r("app.string.button_reset"))
            .onClick(() => {
              this.gifReset = !this.gifReset;
            }).margin({ left: 3 })


        }.width('100%')
        .height(40).backgroundColor(Color.Pink).margin({bottom:5})
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }){
          GIFComponent({ model: $model, autoPlay: $gifAutoPlay, resetGif: $gifReset })
            .width(this.compWidth)
            .height(this.compHeight)
            .backgroundColor(Color.Yellow)
        } .width(this.compWidth)
        .height(this.compHeight)
        .backgroundColor(Color.Grey)

      }

    }.width('100%')
    .height('100%')
  }

  aboutToAppear() {

  }

  aboutToDisappear() {
    console.log('xxx page2 aboutToDisappear')
  }

  onPageHide() {
    console.log('xxx page2 onPageHide')
  }

  createFile(path: string): number {
    return fs.openSync(path,fs.OpenMode.READ_WRITE|fs.OpenMode.CREATE).fd
  }

  /**
   * 向path写入数据
   *
   * @param path 文件绝对路径
   * @param data 文件内容
   */
  async writeNewFileAsync(path: string, data: ArrayBuffer): Promise<void> {
    let fd =  fs.openSync(path,fs.OpenMode.READ_WRITE|fs.OpenMode.CREATE).fd
    fs.truncateSync(fd)
    fs.writeSync(fd, data)
    fs.fsyncSync(fd)
    fs.closeSync(fd)
  }

  typedArrayToBuffer(array: Uint8Array): ArrayBuffer {
    return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset)
  }
}

