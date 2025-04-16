/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

import { parseGIF, decompressFrames, decompressFrame } from './lib/index'
import util from '@ohos.util';
import { Result, Frame } from '../Result'

export default function gifuctTest() {
  describe('gifuctTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('gifuctParseTest', 0, () => {

      let baseU8Gif = 'R0lGODlhCgAKAJEAAP////8AAAAA/wAAACH5BAAAAAAALAAAAAAKAAoAAAIWjC2Zhyoc3DOgAnXslfqo3mCMBJFMAQA7';
      let base64 = new util.Base64Helper();
      let uint8 = base64.decodeSync(baseU8Gif)
      let gif: Result = parseGIF(uint8);
      expect(gif).not().assertUndefined()
    })
    it('gifuctdecompressFrames1Test', 1, () => {

      let baseU8Gif = 'R0lGODlhCgAKAJEAAP////8AAAAA/wAAACH5BAAAAAAALAAAAAAKAAoAAAIWjC2Zhyoc3DOgAnXslfqo3mCMBJFMAQA7';
      let base64 = new util.Base64Helper();
      let uint8 = base64.decodeSync(baseU8Gif)
      let gif: Result = parseGIF(uint8);
      let frames: ESObject[] = decompressFrames(gif, true)
      let frame0:ESObject = frames[0];

      expect(frame0.patch).not().assertUndefined()


    })
    it('gifuctdecompressFrames2Test', 2, () => {

      let baseU8Gif = 'R0lGODlhCgAKAJEAAP////8AAAAA/wAAACH5BAAAAAAALAAAAAAKAAoAAAIWjC2Zhyoc3DOgAnXslfqo3mCMBJFMAQA7';
      let base64 = new util.Base64Helper();
      let uint8 = base64.decodeSync(baseU8Gif)

      let gif: Result = parseGIF(uint8);
      let frames:ESObject[] = decompressFrames(gif, false)
      let frame0:ESObject = frames[0];
      expect(frame0.patch).assertUndefined()

    })
    it('gifuctdecompressFrame1Test', 3, () => {

      let baseU8Gif = 'R0lGODlhCgAKAJEAAP////8AAAAA/wAAACH5BAAAAAAALAAAAAAKAAoAAAIWjC2Zhyoc3DOgAnXslfqo3mCMBJFMAQA7';
      let base64 = new util.Base64Helper();
      let uint8 = base64.decodeSync(baseU8Gif)
      let gif: Result = parseGIF(uint8);

      let frame0:ESObject = decompressFrame(gif.frames[0], gif.gct, true)

      expect(frame0.patch).not().assertUndefined()


    })
    it('gifuctdecompressFrame2Test', 4, () => {

      let baseU8Gif = 'R0lGODlhCgAKAJEAAP////8AAAAA/wAAACH5BAAAAAAALAAAAAAKAAoAAAIWjC2Zhyoc3DOgAnXslfqo3mCMBJFMAQA7';
      let base64 = new util.Base64Helper();
      let uint8 = base64.decodeSync(baseU8Gif)
      let gif: Result = parseGIF(uint8);
      let frame0:ESObject = decompressFrame(gif.frames[0], gif.gct, false)
      expect(frame0.patch).assertUndefined()
    })


  })
}
