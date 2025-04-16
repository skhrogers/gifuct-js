/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the MIT License, (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://opensource.org/licenses/MIT
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import buffer from '@ohos.buffer';

const unhexTable = new Int8Array([
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 0 - 15
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 16 - 31
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 32 - 47
  +0, +1, +2, +3, +4, +5, +6, +7, +8, +9, -1, -1, -1, -1, -1, -1, // 48 - 63
  -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 64 - 79
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 80 - 95
  -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 96 - 111
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 112 - 127
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 128 ...
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // ... 255
]);

export default class UnescapeBuffer {
  /**
   * A safe fast alternative to decodeURIComponent
   * @param {string} s
   * @param {boolean} decodeSpaces
   * @returns {string}
   */
  unescapeBuffer(s, decodeSpaces) {
    const out = buffer.alloc(s.length);
    let index = 0;
    let outIndex = 0;
    let currentChar;
    let nextChar;
    let hexHigh;
    let hexLow;
    const maxLength = s.length - 2;
    // Flag to know if some hex chars have been decoded
    let hasHex = false;
    while (index < s.length) {
      currentChar = s.charCodeAt(index)
      if (currentChar === 43 /* '+' */
      && decodeSpaces) {
        out[outIndex++] = 32; // ' '
        index++;
        continue;
      }
      if (currentChar === 37 /* '%' */
      && index < maxLength) {
        currentChar = s.charCodeAt(++index);
        hexHigh = unhexTable[currentChar];
        if (!(hexHigh >= 0)) {
          out[outIndex++] = 37; // '%'
          continue;
        } else {
          nextChar = s.charCodeAt(++index);
          hexLow = unhexTable[nextChar];
          if (!(hexLow >= 0)) {
            out[outIndex++] = 37; // '%'
            index--;
          } else {
            hasHex = true;
            currentChar = hexHigh * 16 + hexLow;
          }
        }
      }
      out[outIndex++] = currentChar;
      index++;
    }
    return hasHex ? out.subarray(0, outIndex) : out;
  }
}