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
import { GIFFrame } from '../display/GIFFrame'

export type ParsedFrameWithoutPatch = Omit<GIFFrame, 'patch'>

export function prePatchGIF(frames: ParsedFrameWithoutPatch[], patchFrame?: (inputFrame: ParsedFrameWithoutPatch) => Uint8ClampedArray) {
    // 初次绘制
    let filterCriteria = (item) => {
        if (!item['patch']) {
            return true
        }
    }

    frames.filter(filterCriteria, frames)
        .flatMap((frame) => {
            if (patchFrame) {
                frame['patch'] = patchFrame(frame);
                frame['colorTable'] = null
                frame['pixels'] = null
                frame['transparentIndex'] = null
            } else {
                frame['patch'] = generatePatch(frame);
                frame['colorTable'] = null
                frame['pixels'] = null
                frame['transparentIndex'] = null
            }
        })
    return frames as GIFFrame[];
}

export function generatePatch(image: ParsedFrameWithoutPatch) {
    if (!image) {
        return undefined;
    }
    var totalPixels = image.pixels.length;
    var patchData = new Uint8ClampedArray(totalPixels * 4);
    for (var i = 0; i < totalPixels; i++) {
        var pos = i * 4;
        var colorIndex = image.pixels[i];
        var color = image.colorTable[colorIndex] || [0, 0, 0];
        // note: gifuct decode is RGBA,but image.createPixelMap encode is BGRA, so we need swap R & B
        // note: gifuct normal decode  ===== patchData[pos] = color[0]; patchData[pos + 1] = color[1]; patchData[pos + 2] = color[2];
        patchData[pos] = color[2];
        patchData[pos + 1] = color[1];
        patchData[pos + 2] = color[0];
        patchData[pos + 3] = colorIndex !== image.transparentIndex ? 255 : 0;
    }
    return patchData;
}

export function fixLoseGCE(gif) {
    let currentGce = null;
    for (const frame of gif.frames) {
        currentGce = frame.gce ? frame.gce : currentGce;
        // fix losing graphic control extension for same frames
        if ("image" in frame && !("gce" in frame)) {
            frame.gce = currentGce;
        }
    }
}