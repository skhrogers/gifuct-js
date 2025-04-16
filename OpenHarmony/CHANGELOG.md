## 2.1.1-rc.0
- GIF解码能力默认设置为硬解码

## 2.1.0
- 在DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)上验证通过
- 修复装饰器升级后，初始播放速度异常的问题
- 升级状态管理器V2
- 同时支持V1,V2装饰器

## 2.1.0-rc.1
- 修复装饰器升级后，初始播放速度异常的问题

## 2.1.0-rc.0
- 升级状态管理器V2

## 2.0.5
- 2.0.5正式版本

## 2.0.5-rc.3
- 修复软解码加载gif图片重影问题
- 修复软解码加载gif动画播放异常

## 2.0.5-rc.2
- 适配DevEco Studio: 4.1 (4.1.3.414), SDK: API11 (4.1.0.55)
- 修复对patchBuffer变量类型转化为ArrayBuffer
- 修复taskpool.execute()函数的返回类型

## 2.0.5-rc.1
- 修复二次加载图片残留图像问题

## 2.0.5-rc.0
- 修复部分图片链接网络请求失败问题

## 2.0.4
- 适配DevEco Studio: 4.0 (4.0.3.512), SDK: API10 (4.0.10.9)
- ArkTs语法适配

## 2.0.3
- 修复多次加载绘制动画，画布出现动画重新重叠的问题
- 修复多次点击绘制动画按钮，概率性出现this.model.getFrames()[this.frameIndex]会为undefined，导致crash问题

## 2.0.2
- 修复读取this.model.getFrames()[0]元素dims为undefined问题
- 修复点击重置播放动画重叠问题 

## 2.0.1
- 依赖OpenHarmony的媒体子系统Image模块,新增gif硬解码能力,默认开启硬解码功能
- 保留软解码功能,使用taskpool替代worker进行子线程耗时软解码解码
- ArkUI自定义组件支持设置宽高,背景等基础组件通用属性,因此删除 setSize 和 setBackgroundColor接口,用户可在ArkUI链式配置
- 适配DevEco Studio: 4.0 Canary1(4.0.3.212)
- 适配SDK: API10(4.0.8.3)

## 2.0.0
- 包管理工具由npm切换为ohpm
- 适配DevEco Studio: 3.1Beta2(3.1.0.400)
- 适配SDK: API9 Release(3.2.11.9)

## 0.2.0
- 名称由ohos-gif-drawable 修改为 gif-drawable
- 旧的包@ohos/ohos-gif-drawable已不维护，请使用新包@ohos/gif-drawable

## 0.1.0
专门为OpenHarmony打造的一款GIF图像渲染库,支持能力如下：

- 支持播放GIF图片。

- 支持控制GIF播放/暂停。

- 支持监听GIF所有帧显示完成后的回调。

- 支持设置显示大小。

- 支持7种不同的展示类型。

- 支持设置显示区域背景颜色。

  

