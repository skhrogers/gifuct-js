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
import { GIFComponentV2, ResourceLoader } from '@ohos/gif-drawable'
import resourceManager from '@ohos.resourceManager';

@Entry
@ComponentV2
struct NetworkLoadTestCasePage {
  @Local model1Page8: GIFComponentV2.ControllerOptions = new GIFComponentV2.ControllerOptions();
  @Local gifAutoPlay1Page8: boolean = true;
  @Local gifReset1Page8: boolean = false;
  @Local gifReset1Page10: boolean = false;
  resourceManager:resourceManager.ResourceManager = getContext(this).resourceManager;
  @Local hint1: string = this.resourceManager.getStringByNameSync('text_gif1_parse').toString();
  @Local hint11: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @Local hint111: string = 'Network ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString()+"(ms)";
  gif1LoopCount = 0;
  @Local model2Page8: GIFComponentV2.ControllerOptions = new GIFComponentV2.ControllerOptions();
  @Local gifAutoPlay2Page8: boolean = true;
  @Local gifReset2Page8: boolean = false;
  @Local hint2: string = this.resourceManager.getStringByNameSync('text_gif2_parse').toString();
  @Local hint22: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @Local hint222: string = 'Network ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString()+"(ms)";
  gif2LoopCount = 0;
  @Local model3Page8: GIFComponentV2.ControllerOptions = new GIFComponentV2.ControllerOptions();
  @Local gifAutoPlay3Page8: boolean = true;
  @Local gifReset3Page8: boolean = false;
  @Local hint3: string = this.resourceManager.getStringByNameSync('text_gif3_parse').toString();
  @Local hint33: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @Local hint333: string = 'Network ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString()+"(ms)";
  gif3LoopCount = 0;
  canClick1: boolean = true;
  canClick2: boolean = true;
  canClick3: boolean = true;

  build() {
    Scroll() {
      Column() {
        Column() {
          Text(this.hint1)
          Text(this.hint11)
          Text(this.hint111)

          Button($r('app.string.button_draw_gif1'))
            .onClick(() => {
              if (this.canClick1) {
                this.canClick1 = false;
                this.model1Page8.destroy();

                let s1 = new Date().getTime();
                let modelx = new GIFComponentV2.ControllerOptions()
                modelx
                  .setLoopFinish(() => {
                    this.gif1LoopCount++;
                    this.hint11 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gif1LoopCount + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString();
                  })

                  .setScaleType(GIFComponentV2.ScaleType.FIT_CENTER)
                  .setSpeedFactor(1)
                  .setOpenHardware(false)


                ResourceLoader.downloadDataWithContext(getContext(this), {
                  url: 'https://gd-hbimg.huaban.com/e0a25a7cab0d7c2431978726971d61720732728a315ae-57EskW_fw658'
                }, (sucBuffer: ArrayBuffer) => {
                  modelx.loadBuffer(sucBuffer, () => {
                    let e1 = new Date().getTime();
                    this.hint111 = 'Network ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + " " + (e1 - s1) + 'ms'
                    console.log('The network parsing successfully callback drawing')
                    this.gifAutoPlay1Page8 = true;
                    this.model1Page8 = modelx;
                    this.canClick1 = true;
                  })
                }, (err: string) => {
                })
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {
              this.gifAutoPlay1Page8 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay1Page8 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              console.log("Click to reset play");
              this.gifReset1Page8 = !this.gifReset1Page8;
            })
          GIFComponentV2({ model: this.model1Page8!!, autoPlay: this.gifAutoPlay1Page8!!, resetGif: this.gifReset1Page8!! })
            .width(200).height(200)
        }.backgroundColor(Color.Gray)

        Column() {
          Text(this.hint2)
          Text(this.hint22)
          Text(this.hint222)
          Button($r('app.string.button_draw_gif2'))
            .onClick(() => {
              if (this.canClick2) {
                this.canClick2 = false
                this.model2Page8.destroy();
                let s2 = new Date().getTime();
                let modelx = new GIFComponentV2.ControllerOptions()
                modelx
                  .setLoopFinish(() => {
                    this.gif2LoopCount++;
                    this.hint22 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gif2LoopCount + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString();
                  })

                  .setScaleType(GIFComponentV2.ScaleType.FIT_XY)
                  .setSpeedFactor(3)
                  .setOpenHardware(false)

                ResourceLoader.downloadDataWithContext(getContext(this), {
                  url: 'https://pic.ibaotu.com/gif/18/17/16/51u888piCtqj.gif!fwpaa70/fw/700'
                }, (sucBuffer: ArrayBuffer) => {
                  modelx.loadBuffer(sucBuffer, () => {
                    let e2 = new Date().getTime();
                    this.hint222 = 'Network ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + " " + (e2 - s2) + 'ms'
                    console.log('The network parsing successfully callback drawing')
                    this.gifAutoPlay2Page8 = true;
                    this.model2Page8 = modelx;
                    this.canClick2 = true;
                  })
                }, (err: string) => {
                })
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {
              this.gifAutoPlay2Page8 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay2Page8 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              this.gifReset2Page8 = !this.gifReset2Page8;
            })
          GIFComponentV2({ model: this.model2Page8!!, autoPlay: this.gifAutoPlay2Page8!!, resetGif: this.gifReset2Page8!! })
            .width(200).height(200)
        }.backgroundColor(Color.Yellow)

        Column() {
          Text(this.hint3)
          Text(this.hint33)
          Text(this.hint333)
          Button($r('app.string.button_draw_gif3'))
            .onClick(() => {
              if (this.canClick3) {
                this.canClick3 = false;
                this.model3Page8.destroy();
                let s3 = new Date().getTime();
                let modelx = new GIFComponentV2.ControllerOptions()
                modelx
                  .setLoopFinish(() => {
                    this.gif3LoopCount++;
                    this.hint33 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gif3LoopCount + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString();
                  })

                  .setScaleType(GIFComponentV2.ScaleType.FIT_END)
                  .setSpeedFactor(3)
                  .setOpenHardware(false)

                ResourceLoader.downloadDataWithContext(getContext(this), {
                  url: 'https://res.vmallres.com/cmscdn/CN/2023-03/7052a601ac3e428c84c9415ad9734735.gif'
                }, (sucBuffer:ArrayBuffer) => {
                  modelx.loadBuffer(sucBuffer, () => {
                    let e3 = new Date().getTime();
                    this.hint333 = 'Network ' + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + " " + (e3 - s3) + 'ms'
                    console.log('The network parsing successfully callback drawing')
                    this.gifAutoPlay3Page8 = false;
                    this.model3Page8 = modelx;
                    this.canClick3 = true
                  })
                }, (err:string) => {
                })
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {

              this.gifAutoPlay3Page8 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay3Page8 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              this.gifReset3Page8 = !this.gifReset3Page8;
            })
          GIFComponentV2({ model: this.model3Page8!!, autoPlay: this.gifAutoPlay3Page8!!, resetGif: this.gifReset3Page8!! })
            .width(200).height(200)
        }.backgroundColor(Color.Pink)
      }
    }
    .height('100%').width('100%')
  }
}

