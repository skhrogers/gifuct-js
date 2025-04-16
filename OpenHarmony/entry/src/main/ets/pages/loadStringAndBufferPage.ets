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
import resourceManager from '@ohos.resourceManager';

@Entry
@Component
struct LoadStringAndBufferPage {
  gifFile1: string = ''
  gifFile2: string = ''
  gifFile3: string = ''
  resourceManager:resourceManager.ResourceManager = getContext(this).resourceManager
  @State gifhint1: string = this.resourceManager.getStringByNameSync('data_is_saved').toString();
  @State gifText: string = this.resourceManager.getStringByNameSync('data_save_remind').toString();
  @State model1Page10: GIFComponent.ControllerOptions = new GIFComponent.ControllerOptions();
  @State gifAutoPlay1Page10: boolean = true;
  @State gifReset1Page10: boolean = false;

  @State hint1: string = this.resourceManager.getStringByNameSync('text_gif1_parse').toString();
  @State hint11: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @State hint111: string = 'LoadString ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString()+"(ms)";
  gif1LoopCount = 0;
  @State model2Page10: GIFComponent.ControllerOptions = new GIFComponent.ControllerOptions();
  @State gifAutoPlay2Page10: boolean = true;
  @State gifReset2Page10: boolean = false;
  @State hint2: string = this.resourceManager.getStringByNameSync('text_gif2_parse').toString();
  @State hint22: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @State hint222: string = 'LoadString ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString()+"(ms)";
  gif2LoopCount = 0;
  @State model3Page10: GIFComponent.ControllerOptions = new GIFComponent.ControllerOptions();
  @State gifAutoPlay3Page10: boolean = true;
  @State gifReset3Page10: boolean = false;
  @State hint3: string = this.resourceManager.getStringByNameSync('text_gif3_parse').toString();
  @State hint33: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @State hint333: string = 'LoadString ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString()+"(ms)";
  gif3LoopCount = 0;
  canClick1: boolean = true;
  canClick2: boolean = true;
  canClick3: boolean = true;

  /**
   * 新建文件
   * @param path 文件绝对路径及文件名
   * @return number 文件句柄id
   */
  createFile(path: string): number {
    return fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).fd
  }

  /**
   * 向path写入数据
   *
   * @param path 文件绝对路径
   * @param data 文件内容
   */
  async writeNewFileAsync(path: string, data: ArrayBuffer): Promise<void> {
    try {
      let fd = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).fd
      fs.truncateSync(fd)
      fs.writeSync(fd, data)
      fs.fsyncSync(fd)
      fs.closeSync(fd)
    } catch (e) {
      console.log("FileUtils - Failed to writeFile for " + e)
    }
  }

  build() {
    Scroll() {
      Column() {
        Text(this.gifhint1)
        Button($r("app.string.button_save_private_path"))
          .onClick(() => {
            getContext(this)['resourceManager'].getMediaContent($r('app.media.giftest1').id)
              .then(data => {
                let path1 = getContext(this)['filesDir'] + '/giftest1.gif'
                this.createFile(path1);
                this.writeNewFileAsync(path1, this.typedArrayToBuffer(data)).then(() => {
                  this.gifFile1 = path1
                  this.gifhint1 = this.resourceManager.getStringByNameSync('data_write_success').toString()  + path1
                })
              }).catch((err:string) => {
              console.log('parse gif err=' + err)
            })

            getContext(this)['resourceManager'].getMediaContent($r('app.media.giftest2').id)
              .then(data => {
                let path2 = getContext(this)['filesDir'] + '/giftest2.gif'
                this.createFile(path2);
                this.writeNewFileAsync(path2, this.typedArrayToBuffer(data)).then(() => {
                  this.gifFile2 = path2
                  this.gifhint1 = this.resourceManager.getStringByNameSync('data_write_success').toString() + path2
                })
              })
              .catch((err:string) => {
                console.log('parse gif err=' + err)
              })
            getContext(this)['resourceManager'].getMediaContent($r('app.media.gifSample').id)
              .then(data => {
                let path3 = getContext(this)['filesDir'] + '/gifSample.gif'
                this.createFile(path3);
                this.writeNewFileAsync(path3, this.typedArrayToBuffer(data)).then(() => {
                  this.gifFile3 = path3
                  this.gifhint1 = this.resourceManager.getStringByNameSync('data_write_success').toString()  + path3
                })
              })
              .catch((err:string) => {
                console.log('parse gif err=' + err)
              })

          })
        Text(this.gifText)
        Column() {
          Text(this.hint1)
          Text(this.hint11)
          Text(this.hint111)
          Button($r('app.string.button_draw_gif1'))
            .onClick(() => {
              if (this.canClick1 && this.gifFile1) {
                this.canClick1 = false
                this.gifAutoPlay1Page10 = false;
                this.model1Page10.destroy();
                let s1 = new Date().getTime();
                let modelxPage10 = new GIFComponent.ControllerOptions()
                modelxPage10
                  .setLoopFinish(() => {
                    this.gif1LoopCount++;
                    this.hint11 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gif1LoopCount + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString();
                  })
                  .setScaleType(GIFComponent.ScaleType.FIT_CENTER)
                  .setSpeedFactor(1)
                  .setOpenHardware(false)

                ResourceLoader.loadString(this.gifFile1).then((buffer) => {
                  modelxPage10.loadBuffer(buffer, () => {
                    let e1 = new Date().getTime();
                    this.hint111 = 'LoadString ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + " " + (e1 - s1) + 'ms'
                    console.log('LoadString parsing successfully callback drawing')
                    this.gifAutoPlay1Page10 = true;
                    this.model1Page10 = modelxPage10;
                    this.canClick1 = true;
                  })
                })
              } else if (!this.gifFile2) {
                this.gifText = this.resourceManager.getStringByNameSync('data_btn1_save').toString();
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {
              this.gifAutoPlay1Page10 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay1Page10 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              console.log('ck to reset play')
              this.gifReset1Page10 = !this.gifReset1Page10;
            })
          GIFComponent({ model: $model1Page10, autoPlay: $gifAutoPlay1Page10, resetGif: $gifReset1Page10 })
            .width(200).height(200)
        }.backgroundColor(Color.Blue)

        Column() {
          Text(this.hint2)
          Text(this.hint22)
          Text(this.hint222)
          Button($r('app.string.button_draw_gif2'))
            .onClick(() => {
              if (this.canClick2 && this.gifFile2) {
                this.canClick2 = false
                this.gifAutoPlay2Page10 = false;
                this.model2Page10.destroy();
                let s2Page10 = new Date().getTime();
                let modelxPage10 = new GIFComponent.ControllerOptions()
                modelxPage10
                  .setLoopFinish(() => {
                    this.gif2LoopCount++;
                    this.hint22 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " +this.gif2LoopCount + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString();
                  })
                  .setScaleType(GIFComponent.ScaleType.FIT_XY)
                  .setSpeedFactor(3)
                  .setOpenHardware(false)

                ResourceLoader.loadString(this.gifFile2).then((buffer) => {
                  modelxPage10.loadBuffer(buffer, () => {
                    let e2Page10 = new Date().getTime();
                    this.hint222 = 'LoadStringByWorker ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + " " + (e2Page10 - s2Page10) + 'ms'
                    console.log('LoadStringByWorker parsing successfully callback drawing')
                    this.gifAutoPlay2Page10 = true;
                    this.model2Page10 = modelxPage10;
                    this.canClick2 = true;
                  })
                })
              } else if (!this.gifFile2) {
                this.gifText = this.resourceManager.getStringByNameSync('data_btn2_save').toString();
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {
              this.gifAutoPlay2Page10 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay2Page10 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              this.gifReset2Page10 = !this.gifReset2Page10;
            })
          GIFComponent({ model: $model2Page10, autoPlay: $gifAutoPlay2Page10, resetGif: $gifReset2Page10 })
            .width(200).height(200)
        }.backgroundColor(Color.Green)

        Column() {
          Text(this.hint3)
          Text(this.hint33)
          Text(this.hint333)

          Button($r('app.string.button_draw_gif3'))
            .onClick(() => {
              if (this.canClick3 && this.gifFile3) {
                this.canClick3 = false;
                this.gifAutoPlay3Page10 = false;
                this.model3Page10.destroy();
                let s3 = new Date().getTime();
                let modelxPage10 = new GIFComponent.ControllerOptions()
                modelxPage10
                  .setLoopFinish(() => {
                    this.gif3LoopCount++;
                    this.hint33 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gif3LoopCount + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString();
                  })
                  .setScaleType(GIFComponent.ScaleType.FIT_END)
                  .setSpeedFactor(3)
                  .setOpenHardware(false)

                ResourceLoader.loadString(this.gifFile3).then((buffer) => {
                  modelxPage10.loadBuffer(buffer, () => {
                    let e3 = new Date().getTime();
                    this.hint333 = 'LoadBuffer ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + " " + (e3 - s3) + 'ms'
                    console.log('LoadBuffer parsing successfully callback drawing')
                    this.gifAutoPlay3Page10 = true;
                    this.model3Page10 = modelxPage10;
                    this.canClick3 = true;
                  })
                })
              } else if (!this.gifFile3) {
                this.gifText = this.resourceManager.getStringByNameSync('data_btn3_save').toString();
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {
              this.gifAutoPlay3Page10 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay3Page10 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              this.gifReset3Page10 = !this.gifReset3Page10;
            })
          GIFComponent({ model: $model3Page10, autoPlay: $gifAutoPlay3Page10, resetGif: $gifReset3Page10 })
            .width(200).height(200)
        }.backgroundColor(Color.Orange)
      }
    }
    .height('100%').width('100%')
  }

  typedArrayToBuffer(array: Uint8Array): ArrayBuffer {
    return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset)
  }
}

