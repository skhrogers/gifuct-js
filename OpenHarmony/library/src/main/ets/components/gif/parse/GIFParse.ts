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
import { decompressFrames, parseGIF } from '../../3rd_party/gifuct/lib/index'
import { fixLoseGCE, prePatchGIF, ParsedFrameWithoutPatch } from '../utils/ParseHelperUtils'
import { GIFFrame } from '../display/GIFFrame'

export function parseBufferToFrame(arraybuffer: ArrayBuffer, patchRule?: (input: ParsedFrameWithoutPatch[]) => GIFFrame[]): GIFFrame[] {
    let gif = parseGIF(arraybuffer)
    fixLoseGCE(gif)
    let origins = decompressFrames(gif, false)
    if (patchRule) {
        // 如果用户对于像素点操作有要求可以自行替换
        return patchRule(origins);
    }
    return prePatchGIF(origins);

}



