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

import image from '@ohos.multimedia.image';
import taskpool from '@ohos.taskpool';
import { GIFFrame } from './GIFFrame';
import { parseBufferToFrame } from '../parse/GIFParse';

@Concurrent
export function parseByTaskpool(buffer: ArrayBuffer): GIFFrame[] {
  let images = parseBufferToFrame(buffer);
  return images;
}

@Component
struct GIFComponent {
  @Watch('watchModel') @Link model: GIFComponent.ControllerOptions;
  @Watch('watchAutoPlay') @Link autoPlay: boolean;
  @Watch('watchResetGif') @Link resetGif: boolean;
  bindScroller?: boolean = false
  private canvasSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.canvasSettings)
  // 当前帧数位置
  private frameIndex = 0;
  // gif的帧长度
  private frameLength = 0;
  // 当前用户设置组件宽
  private canvasWidth: number = 0;
  // 当前用户设置组件高
  private canvasHeight: number = 0;
  private lastWidth: number = 0;
  private lastHeight: number = 0;
  // 第一帧图片宽度
  private g1Width: number = 0;
  // 第一帧图片高度
  private g1Height: number = 0;
  // 定时器ID
  private timerId: number = 0;
  // 缩放 组件/图片 宽度比
  private scaleW: number = 1;
  // 缩放 组件/图片 高度比
  private scaleH: number = 1;
  // 完整gif播放时间
  private gifLoopDuration: number = 0;
  private startGifLoopTime: number = 0;
  private endGifLoopTime: number = 0;
  // 开始到指定位置的播放时间
  private gifPosFrameDuration: number = 0;
  private startPosFrameTime: number = 0;
  private endPosFrameTime: number = 0;
  private canvasReady: boolean = false;
  private onReadyNext: () => void = () => {
  }
  private firstDrawFlag: boolean = false;

  build() {
    Canvas(this.canvasContext)
      .width('100%')
      .height('100%')
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.canvasWidth = newValue.width as number;
        this.canvasHeight = newValue.height as number;
        if (this.canvasWidth <= 0 || this.canvasHeight <= 0) {
          // 宽或者高为0,无需绘制
        } else {
          if ((this.canvasWidth != this.lastWidth || this.canvasHeight != this.lastHeight) || this.firstDrawFlag) {
            this.firstDrawFlag = false;
            this.lastWidth = this.canvasWidth;
            this.lastHeight = this.canvasHeight;
            this.readyParseGIF();
          }
        }
      }).onReady(() => {
      this.canvasReady = true;
      if (this.onReadyNext) {
        this.onReadyNext();
        this.onReadyNext = () => {

        };
      }
    })
  }

  watchAutoPlay() {
    if (this.autoPlay) {
      this.renderFrames()
    } else {
    }
  }

  watchResetGif() {
    clearTimeout(this.timerId);
    this.canvasContext.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
    this.frameIndex = 0;
    this.gifPosFrameDuration = 0;
    this.gifLoopDuration = 0;
    this.renderFrames();
  }

  watchModel() {
    this.whetherWaitSize();
  }

  aboutToAppear() {
    this.canvasReady = false;
    this.whetherWaitSize(true);
  }

  whetherWaitSize(drawFirst?: boolean) {
    if (this.canvasWidth <= 0 || this.canvasHeight <= 0) {
      if (drawFirst) {
        this.firstDrawFlag = true;
      }
    } else {
      // 宽高存在,可以直接绘制GIF
      this.runNextFunction((): void => this.readyParseGIF())
    }
  }

  aboutToDisappear() {
    clearTimeout(this.timerId)
  }

  onPageShow() {
  }

  onPageHide() {

  }

  onBackPress() {

  }

  private readyParseGIF() {

    // 保证当前model存在,并且有帧数据 才会执行后续绘制
    if (!!!this.model || !!!this.model.getFrames() || !!!this.model.getFrames()[0]) {
      return;
    }

    // clear timeout
    clearTimeout(this.timerId);

    //重新加载绘制动画时先清空画布，防止动画重新重叠
    this.canvasContext.resetTransform();
    this.canvasContext.clearRect(0, 0, this.canvasContext.width, this.canvasContext.height);

    this.frameIndex = 0;
    this.frameLength = this.model.getFrames().length;

    if (this.model.getOpenHardware()) {
      this.g1Width = px2vp(this.model.getFrames()[0].dims.left) + px2vp(this.model.getFrames()[0].dims.width);
      this.g1Height = px2vp(this.model.getFrames()[0].dims.top) + px2vp(this.model.getFrames()[0].dims.height);
    } else {
      this.g1Width = px2vp(this.model.getFrames()[0].dims.left) + px2vp(this.model.getFrames()[0].dims.width);
      this.g1Height = px2vp(this.model.getFrames()[0].dims.top) + px2vp(this.model.getFrames()[0].dims.height);
    }

    this.scaleW = this.canvasWidth / (this.g1Width * 1.0)
    this.scaleH = this.canvasHeight / (this.g1Height * 1.0)


    if (this.isSeekTo()) {
      this.drawSeekToFrame();
    } else {
      this.renderFrames()
    }
  }

  /**
   * 判断用户是否设置了直接展示第几帧画面。
   */
  private isSeekTo() {
    if (this.model.getSeekTo() != null && this.model.getSeekTo() >= 0) {
      return true;
    }
    return false;
  }

  /**
   * 绘制直接到第几帧方法，由于gif非第一帧数据可能是不全的，这里采用逐帧渲染的方式来绘制保证图像的完整性
   */
  private drawSeekToFrame() {
    this.autoPlay = false;
    let seekIndex: number = this.model.getSeekTo() < this.model.getFrames()
      .length ? this.model.getSeekTo() : this.model.getFrames().length - 1
    if (this.model.getOpenHardware()) {
      this.frameIndex = seekIndex;
      this.drawFrame();
    } else {
      for (let i = 0; i < this.model.getSeekTo(); i++) {
        this.frameIndex = i;
        this.drawFrame();
      }
    }
  }

  private runNextFunction(nextFunction: () => void) {
    if (!this.canvasReady) {
      this.onReadyNext = nextFunction;
    } else {
      nextFunction();
    }
  }

  private renderFrames() {
    // 保证model存在,并且帧数有数据
    if (!!!this.model || !!!this.model.getFrames()) {
      return;
    }
    let start = new Date().getTime();
    if (this.frameIndex === 0) {
      // 如果是第一帧，我们只从开始渲染前记录时间
      this.startPosFrameTime = start;
      this.startGifLoopTime = start;
    }
    // draw Frame
    this.drawFrame();

    // 记录渲染结束时间点
    let end = new Date().getTime();
    let diff = end - start

    if (this.autoPlay) {
      //确保指定帧存在，用于动画重绘
      if (!!!this.model.getFrames()[this.frameIndex]) {
        return;
      }
      // 理论上该帧在屏幕上保留的时间
      let stayTime: number = this.model.getFrames()[this.frameIndex].delay;
      if (this.model.getSpeedFactor()) {
        stayTime = this.model.getFrames()[this.frameIndex].delay / (this.model.getSpeedFactor() * 1.0);
      }
      // 减去程序执行消耗，剩余的准确延迟时间
      let delayTime = Math.max(0, Math.floor(stayTime - diff));


      this.endGifLoopTime = end;
      // 当前gif到第N帧,所对应的N渲染时间，和N-1的停留时间。（第一帧只有渲染时间没有停留时间）
      let loopStayTime = this.endGifLoopTime - this.startGifLoopTime;
      this.startGifLoopTime = end;

      // 整个gif累计的时长;
      this.gifLoopDuration += loopStayTime;

      // 返回gif一次循环结束回调，并且把当前循环的时间给出
      if (this.frameIndex === (this.frameLength - 1) && this.model.getLoopFinish()) {
        (this.model.getLoopFinish())(this.gifLoopDuration);
        this.gifLoopDuration = 0;
      }

      if (this.frameIndex < this.model.getPosition()) {
        this.endPosFrameTime = end;
        // 当前gif到第N帧,所对应的N渲染时间，和N-1的停留时间。（第一帧只有渲染时间没有停留时间）
        let posStayTime = this.endPosFrameTime - this.startPosFrameTime;
        this.startPosFrameTime = end;

        // 在position中累计的时长
        this.gifPosFrameDuration += posStayTime;
      }

      if (this.frameIndex === (this.model.getPosition() - 1) && this.model.getPositionFinish()) {
        (this.model.getPositionFinish())(this.gifPosFrameDuration);
        this.gifPosFrameDuration = 0;
      }

      // update the frame index
      this.frameIndex++;
      if (this.frameIndex >= this.frameLength) {
        this.frameIndex = 0;
      }

      this.timerId = setTimeout(() => {
        this.renderFrames()
      }, delayTime)
    }
  }

  private drawFrame() {
    // 保证model存在,并且帧数有数据
    if (!!!this.model || !!!this.model.getFrames()) {
      return;
    }
    // get current frame
    let frame: GIFFrame = this.model.getFrames()[this.frameIndex];
    if (!frame || !this.canvasContext) {
      // 数据保护，绘制保护
      return;
    }

    if (frame['drawPixelMap']) {
      this.canvasDrawPixelMap(frame, frame['drawPixelMap'])
    }

  }

  // 具体绘制过程
  private canvasDrawPixelMap(frame: GIFFrame, pixelmap: ImageBitmap | PixelMap) {
    if (this.model.getOpenHardware()) {
      this.canvasContext.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
      this.preScaleType()
      this.canvasContext.drawImage(pixelmap, px2vp(frame.dims.left), px2vp(frame.dims.top))
    } else {
      let disposal = 0
      // disposal value is from preFrame
      if (this.frameIndex >= 1) {
        let preFrame: GIFFrame = this.model.getFrames()[this.frameIndex-1]
        disposal = preFrame.disposalType
      }
      if (disposal === GIFComponent.FrameDisposalType.DISPOSE_RestoreBackground) {
        this.canvasContext.clearRect(0, 0, px2vp(frame.dims.left) + px2vp(frame.dims.width), px2vp(frame.dims.top) + px2vp(frame.dims.height))
      }
      if (this.model.getFrames()[this.frameIndex]
        .disposalType === GIFComponent.FrameDisposalType.DISPOSE_PreviousStatus) {

      } else {
          this.preScaleType();
          this.canvasContext.drawImage(pixelmap, px2vp(frame.dims.left), px2vp(frame.dims.top))

      }
    }
  }

  private drawFIT_START() {
    let minScale = this.scaleW >= this.scaleH ? this.scaleH : this.scaleW;
    this.canvasContext.setTransform(minScale, 0, 0, minScale, 0, 0)
  }

  private drawFIT_END() {
    let minScale = this.scaleW >= this.scaleH ? this.scaleH : this.scaleW;
    this.canvasContext.setTransform(minScale, 0, 0, minScale, 0, 0)
    this.canvasContext.translate((this.canvasWidth - this.g1Width * minScale) / (minScale * 1.0), (this.canvasHeight - this.g1Height * minScale) / (minScale * 1.0))
  }

  private drawFIT_CENTER() {
    let minScale = this.scaleW >= this.scaleH ? this.scaleH : this.scaleW;
    this.canvasContext.setTransform(minScale, 0, 0, minScale, 0, 0)
    this.canvasContext.translate((this.canvasWidth - this.g1Width * minScale) / (minScale * 2.0), (this.canvasHeight - this.g1Height * minScale) / (minScale * 2.0))
  }

  private drawCENTER() {
    this.canvasContext.setTransform(1, 0, 0, 1, (this.canvasWidth - this.g1Width) / (2.0), (this.canvasHeight - this.g1Height) / (2.0))
  }

  private drawCENTER_CROP() {
    let maxScale = this.scaleW >= this.scaleH ? this.scaleW : this.scaleH;
    this.canvasContext.setTransform(maxScale, 0, 0, maxScale, 0, 0)
    this.canvasContext.translate((this.canvasWidth - this.g1Width * maxScale) / (maxScale * 2.0), (this.canvasHeight - this.g1Height * maxScale) / (maxScale * 2.0))
  }

  private drawFIT_XY() {
    this.canvasContext.setTransform(this.scaleW, 0, 0, this.scaleH, 0, 0);
  }

  private drawCENTER_INSIDE() {
    let minScale = this.scaleW >= this.scaleH ? this.scaleH : this.scaleW;
    if (minScale < 1) {
      let minScale = this.scaleW >= this.scaleH ? this.scaleH : this.scaleW;
      this.canvasContext.setTransform(minScale, 0, 0, minScale, 0, 0)
      this.canvasContext.translate((this.canvasWidth - this.g1Width * minScale) / (minScale * 2.0), (this.canvasHeight - this.g1Height * minScale) / (minScale * 2.0))
    } else {
      this.canvasContext.setTransform(1, 0, 0, 1, (this.canvasWidth - this.g1Width) / (2.0), (this.canvasHeight - this.g1Height) / (2.0))
    }
  }

  private preScaleType() {
    let scaleType: number = this.model.getScaleType();
    if (scaleType === GIFComponent.ScaleType.FIT_START) {
      this.drawFIT_START();
    } else if (scaleType === GIFComponent.ScaleType.FIT_END) {
      this.drawFIT_END();
    } else if (scaleType === GIFComponent.ScaleType.FIT_CENTER) {
      this.drawFIT_CENTER();
    } else if (scaleType === GIFComponent.ScaleType.FIT_CENTER) {
      this.drawCENTER();
    } else if (scaleType === GIFComponent.ScaleType.CENTER_CROP) {
      this.drawCENTER_CROP();
    } else if (scaleType === GIFComponent.ScaleType.FIT_XY) {
      this.drawFIT_XY();
    } else if (scaleType === GIFComponent.ScaleType.CENTER_INSIDE) {
      this.drawCENTER_INSIDE();
    } else {
      this.drawFIT_CENTER();
    }
  }
}

namespace GIFComponent {
  export enum FrameDisposalType {
    // 0 - No disposal specified. The decoder is not required to take any action.
    // 不使用处置方法
    DISPOSE_Nothing = 0,
    // 1-Do not dispose. The graphic is to be left in place.
    // 不处置图形，把图形从当前位置移去
    DISPOSE_NotResolve = 1,
    // 2 - Restore to background color. The area used by the graphic must be restored to the background color.
    // 回复到背景色
    DISPOSE_RestoreBackground = 2,
    // 3-Restore to previous
    DISPOSE_PreviousStatus = 3
  }

  export enum ScaleType {

    // 图像位于用户设置组件左上角显示，图像会缩放至全部展示
    FIT_START = 0,
    // 图像位于用户设置组件右下角显示，图像会缩放至全部展示
    FIT_END = 1,
    // 图像位于用户设置组件居中显示，图像会缩放至全部展示
    FIT_CENTER = 2,
    // 图像绝对居中显示，不缩放
    CENTER = 3,
    // 小端，缩放至组件大小，大端裁剪超出位置
    CENTER_CROP = 4,
    // 图像拉伸至组件大小
    FIT_XY = 5,
    // 如果图像大于组件则缩放执行FIT_CENTER,如果图像小于组件 则居中执行CENTER
    CENTER_INSIDE = 6
  }

  export class ControllerOptions {
    // gif帧
    private frames: GIFFrame[] = new Array<GIFFrame>();
    // gif遍历结束回调
    private loopFinish: (loopTime?: number) => void = () => {
    };
    // 从1-第N帧position
    private position: number = -1;
    // gif 从0-某一帧position回调
    private positionFinish: (posTime?: number) => void = () => {
    };
    // scaleType
    private scaleType: ScaleType = GIFComponent.ScaleType.FIT_START;
    // speed 速率因子 设置为2就是2倍速运行动画
    private speedFactor: number = -1;
    // 跳转至某一帧
    private seekTo: number = -1;
    // 开启硬解码能力
    private openHardware: boolean = true;

    constructor() {
    }

    loadBuffer(buffer: ArrayBuffer, readyRender: (err?: string) => void) {
      if (!this.openHardware) {
        this.userTaskPoolParse(buffer, readyRender)
      } else {
        this.useHardwareParse(buffer, readyRender)
      }
    }

    private userTaskPoolParse(buffer: ArrayBuffer, readyReader: (err?: string) => void) {
      let task = new taskpool.Task(parseByTaskpool, buffer);
      taskpool.execute(task).then((frames: Object) => {
        const imageFrames:GIFFrame[] = Object.values(frames);
        this.createPixelMapAll(imageFrames).then((pixelMaps: PixelMap[]) => {
          if (pixelMaps.length == imageFrames.length) {
            for (let i = 0; i < imageFrames.length; i++) {
              let frame:GIFFrame = imageFrames[i];
              frame.drawPixelMap = pixelMaps[i];
            }
            this.frames = imageFrames;
            readyReader()
          } else {
            readyReader('GIF patch data transfer PixelMap has Error!')
          }
        }).catch((err: string) => {
          readyReader(err)
        })
      }).catch((err: string) => {
        readyReader(err)
      })
    }

    private useHardwareParse(buffer: ArrayBuffer, readyReader: (err?: string) => void) {
      // 硬解码流程
      if(!buffer){
        readyReader("buffer is undefined")
        return
      }
      this.frames = []
      let imageSource = image.createImageSource(buffer);
      if(!imageSource){
        readyReader("imageSource is undefined")
        return
      }
      let decodeOpts: image.DecodingOptions = {
        sampleSize: 1,
        editable: true,
        rotate: 0
      }
      imageSource.createPixelMapList(decodeOpts).then((pixelList: Array<PixelMap>) => {
        //sdk的api接口发生变更：从.getDelayTime() 变为.getDelayTimeList()
        imageSource.getDelayTimeList().then(delayTimes => {
          if (pixelList.length > 0) {
            let pixelmap1 = pixelList[0];
            pixelmap1.getImageInfo().then(imageInfo => {
              for (let i = 0; i < pixelList.length; i++) {
                let frame = new GIFFrame();
                frame.drawPixelMap = pixelList[i];
                frame.dims = { width: imageInfo.size.width, height: imageInfo.size.height, top: 0, left: 0 }
                if (i < delayTimes.length) {
                  frame.delay = delayTimes[i];
                } else {
                  frame.delay = delayTimes[delayTimes.length - 1]
                }
                this.frames.push(frame)
              }
              imageSource.release((err, data) => {
              })
              readyReader();
            }).catch((err: string) => {
              readyReader(err)
            })
          }
        }).catch((err: string) => {
          readyReader(err)
        })
      }).catch((err: string) => {
        readyReader(err)
      })
    }

    getOpenHardware() {
      return this.openHardware;
    }

    setOpenHardware(open: boolean) {
      this.openHardware = open;
      return this;
    }

    getFrames() {
      return this.frames;
    }

    setFrames(images?: GIFFrame[]) {
      if (!!images) {
        this.frames = images;
      }
      return this;
    }

    getLoopFinish() {
      return this.loopFinish;
    }

    setLoopFinish(fn: (loopTime?: number) => void) {
      this.loopFinish = fn
      return this;
    }

    getPositionFinish() {
      return this.positionFinish;
    }

    setPositionFinish(position: number, fn: (posTime?: number) => void) {
      this.position = position;
      this.positionFinish = fn
      return this;
    }

    getPosition() {
      return this.position;
    }


    setScaleType(scaletype: ScaleType) {
      this.scaleType = scaletype
      return this;
    }

    getScaleType() {
      return this.scaleType;
    }


    setSpeedFactor(speed: number) {
      this.speedFactor = speed;
      return this;
    }

    getSpeedFactor() {
      return this.speedFactor;
    }

    setSeekTo(gifPosition: number) {
      this.seekTo = gifPosition;
    }

    getSeekTo() {
      return this.seekTo;
    }

    destroy() {
      this.frames = new Array<GIFFrame>();
      this.loopFinish = () => {
      };
      this.position = -1;
      this.positionFinish = () => {
      };
      this.scaleType = GIFComponent.ScaleType.FIT_START;
      this.speedFactor = 1;
      this.seekTo = 0;
    }

    private typedArrayToBuffer(array: Uint8ClampedArray):ArrayBuffer {
      return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset)
    }

    private createPixelMapAll(frames: GIFFrame[]): Promise<PixelMap[]> {
      let promises: Promise<PixelMap>[] = []
      let filterCriteria = (item: GIFFrame) => {
        if (!item['drawPixelMap']) {
          return true;
        }
        return false;
      }
      frames.filter(filterCriteria, frames).flatMap<void, undefined>((frame: GIFFrame) => {
        let initializationOptions: image.InitializationOptions = {
          'size': {
            'height': frame.dims.height as number,
            'width': frame.dims.width as number
          }
        }
        let patchBuffer:ArrayBuffer = new ArrayBuffer(0);
        if (!!frame.patch) {
          patchBuffer = this.typedArrayToBuffer(frame.patch)
        }
        promises.push(image.createPixelMap(patchBuffer, initializationOptions))
      })
      return Promise.all(promises)
    }
  }
}

export default GIFComponent;
