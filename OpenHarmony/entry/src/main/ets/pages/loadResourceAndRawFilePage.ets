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
import resourceManager from '@ohos.resourceManager'

@Entry
@ComponentV2
struct LoadResourceAndRawFilePage {
  @Local model1Page9: GIFComponentV2.ControllerOptions = new GIFComponentV2.ControllerOptions();
  @Local gifAutoPlay1Page9: boolean = true;
  @Local gifReset1Page9: boolean = false;
  resourceManager:resourceManager.ResourceManager = getContext(this).resourceManager;
  @Local hint1: string = this.resourceManager.getStringByNameSync('text_gif1_parse').toString();
  @Local hint11: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @Local hint111: string = "LoadMedia " + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + "(ms)";
  gif1LoopCountPage9 = 0;
  @Local model2Page9: GIFComponentV2.ControllerOptions = new GIFComponentV2.ControllerOptions();
  @Local gifAutoPlay2Page9: boolean = true;
  @Local gifReset2Page9: boolean = false;
  @Local hint2: string = this.resourceManager.getStringByNameSync('text_gif2_parse').toString();
  @Local hint22: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @Local hint222: string = "LoadMedia " + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + "(ms)";
  gif2LoopCountPage9 = 0;
  @Local model3Page9: GIFComponentV2.ControllerOptions = new GIFComponentV2.ControllerOptions();
  @Local gifAutoPlay3Page9: boolean = true;
  @Local gifReset3Page9: boolean = false;
  @Local hint3: string = this.resourceManager.getStringByNameSync('text_gif3_parse').toString();
  @Local hint33: string = this.resourceManager.getStringByNameSync('text_current_loop').toString();
  @Local hint333: string = "LoadMedia " + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + "(ms)";
  gif3LoopCountPage9 = 0;

  canClick1:boolean = true;
  canClick2:boolean = true;
  canClick3:boolean = true;

  build() {
    Scroll() {
      Column() {
        Column() {
          Text(this.hint1)
          Text(this.hint11)
          Text(this.hint111)
          Button($r('app.string.button_draw_gif1'))
            .onClick(() => {
              if(this.canClick1){
                this.canClick1 = false;
                this.model1Page9.destroy();
                let s1Page9 = new Date().getTime();
                let modelxPage9 = new GIFComponentV2.ControllerOptions()
                modelxPage9
                  .setLoopFinish(() => {
                    this.gif1LoopCountPage9++;
                    this.hint11 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gif1LoopCountPage9 + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString();
                  })
                  .setScaleType(GIFComponentV2.ScaleType.FIT_CENTER)
                  .setSpeedFactor(1)
                  .setOpenHardware(false)

                ResourceLoader.loadMedia($r('app.media.giftest1').id, getContext(this)).then((buffer) => {
                  modelxPage9.loadBuffer(buffer,

                    () => {
                      let e1 = new Date().getTime();
                      this.hint111 =  "LoadMedia " + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + " " + (e1 - s1Page9) + 'ms'
                      console.log('LoadMedia parsing successfully callback drawing');
                      this.gifAutoPlay1Page9 = true;
                      this.model1Page9 = modelxPage9;
                      this.canClick1 = true;
                    })
                })
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {
              this.gifAutoPlay1Page9 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay1Page9 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              console.log("Click to reset play");
              this.gifReset1Page9 = !this.gifReset1Page9;
            })
          GIFComponentV2({ model: this.model1Page9!!, autoPlay: this.gifAutoPlay1Page9!!, resetGif: this.gifReset1Page9!! })
            .width(200).height(200)
        }.backgroundColor(Color.Gray)

        Column() {
          Text(this.hint2)
          Text(this.hint22)
          Text(this.hint222)
          Button($r('app.string.button_draw_gif2'))
            .onClick(() => {
              if(this.canClick2) {
                this.canClick2 = false;
                this.model2Page9.destroy();
                let s2Page9 = new Date().getTime();
                let modelxPage9 = new GIFComponentV2.ControllerOptions()
                modelxPage9
                  .setLoopFinish(() => {
                    this.gif2LoopCountPage9++;
                    this.hint22 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gif2LoopCountPage9 + " " +
                    this.resourceManager.getStringByNameSync('data_time').toString();
                  })

                  .setScaleType(GIFComponentV2.ScaleType.FIT_XY)
                  .setSpeedFactor(2)
                .setOpenHardware(false)


                ResourceLoader.loadMedia($r('app.media.giftest2').id, getContext(this)).then((buffer) => {
                  modelxPage9.loadBuffer(buffer,
                    (error) => {
                      if (error) {
                        console.log('loadMediaByWorker error =' + error)
                      }
                      let e2Page9 = new Date().getTime();
                      this.hint222 = "LoadMedia " + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString()+ " " + (e2Page9 - s2Page9) + 'ms'
                      console.log("Load parsing successfully callback drawing");
                      this.gifAutoPlay2Page9 = true;
                      this.model2Page9 = modelxPage9;
                      this.canClick2 = true;
                    })
                })
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {
              this.gifAutoPlay2Page9 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay2Page9 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              this.gifReset2Page9 = !this.gifReset2Page9;
            })
          GIFComponentV2({ model: this.model2Page9!!, autoPlay: this.gifAutoPlay2Page9!!, resetGif: this.gifReset2Page9!! })
            .width(200).height(200)
        }.backgroundColor(Color.Yellow)

        Column() {
          Text(this.hint3)
          Text(this.hint33)
          Text(this.hint333)

          Button($r('app.string.button_draw_gif3'))
            .onClick(() => {
              if(this.canClick3){
                this.canClick3 = false
              this.model3Page9.destroy();
              let s3Page9 = new Date().getTime();
              let modelxPage9 = new GIFComponentV2.ControllerOptions()
              modelxPage9.setLoopFinish(() => {
                  this.gif3LoopCountPage9++;
                  this.hint33 = this.resourceManager.getStringByNameSync('data_current_loop').toString() + " " + this.gif3LoopCountPage9 + " " +
                  this.resourceManager.getStringByNameSync('data_time').toString();
                })

                .setScaleType(GIFComponentV2.ScaleType.FIT_END)
                .setSpeedFactor(3)
                .setOpenHardware(false)


              ResourceLoader.loadRawFile('gifSample.gif',getContext(this)).then((buffer:ArrayBuffer) => {
                modelxPage9.loadBuffer(buffer, (error) => {
                  if (error) {
                    console.log('loadRawFileByWorker error =' + error)
                  }
                  let e3Page9 = new Date().getTime();
                  this.hint333 = "LoadRawFile " + this.resourceManager.getStringByNameSync('text_loadAndParse_time').toString() + " " + (e3Page9 - s3Page9) + 'ms'
                  console.log('Load parsing successfully callback drawing');
                  this.gifAutoPlay3Page9 = true;
                  this.model3Page9 = modelxPage9;
                  this.canClick3 = true
                })
              })
              }
            })

          Button($r('app.string.button_start_play'))
            .onClick(() => {
              this.gifAutoPlay3Page9 = true;
            })
          Button($r('app.string.button_stop_play'))
            .onClick(() => {
              this.gifAutoPlay3Page9 = false;
            })
          Button($r('app.string.button_reset_play'))
            .onClick(() => {
              this.gifReset3Page9 = !this.gifReset3Page9;
            })
          GIFComponentV2({ model: this.model3Page9!!, autoPlay: this.gifAutoPlay3Page9!!, resetGif: this.gifReset3Page9!! })
            .width(200).height(200)
        }.backgroundColor(Color.Pink)
      }
    }.height('100%').width('100%')
  }

  aboutToAppear() {

  }

  aboutToDisappear() {
    console.log('xxx page1 aboutToDisappear')
  }

  onPageHide() {
    console.log('xxx page1 onPageHide')
  }
}

