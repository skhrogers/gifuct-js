/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http:// www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


// GIF自定义组件
export {  default as GIFComponentV2 } from './src/main/ets/components/gif/display/GIFComponentV2'
export {  default as GIFComponent } from './src/main/ets/components/gif/display/GIFComponent'

// GIF解码数据规范s
export { GIFFrame } from './src/main/ets/components/gif/display/GIFFrame'

// GIF解码能力
export { parseBufferToFrame } from './src/main/ets/components/gif/parse/GIFParse'

// GIF解码部分能力增强
export { ParsedFrameWithoutPatch,
  prePatchGIF,
  generatePatch,
  fixLoseGCE } from './src/main/ets/components/gif/utils/ParseHelperUtils'

// 本地资源网络资源获取能力
export { ResourceLoader } from './src/main/ets/components/gif/utils/ResourceLoader'



