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
import router from '@ohos.router';

@Entry
@ComponentV2
struct Index {
  routerNumber = [0, 1, 2, 3, 4]
  routerArr: RouterData[] = [
    {
      router: "pages/sample1TestCasePage",
      name: $r("app.string.router_default")
    },
    {
      router: "pages/sample2TestCasePage",
      name: $r("app.string.router_alternative")
    },
    {
      router: "pages/networkLoadTestCasePage",
      name: $r("app.string.router_online")
    },
    {
      router: "pages/loadResourceAndRawFilePage",
      name: $r("app.string.router_local_res")
    },
    {
      router: "pages/loadStringAndBufferPage",
      name: $r("app.string.router_local_file")
    }
  ];

  build() {
    Column() {
      Text($r("app.string.text_label_show")).fontSize(35).margin({bottom: 10, top: 10})
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.routerNumber, (item:number) => {
          ListItem() {
            Column({ space: 5 }) {
              Button(this.routerArr[item].name)
                .width("90%")
                .fontSize(18)
                .fontStyle(FontStyle.Normal)
                .onClick(() => {
                  router.pushUrl({ url: this.routerArr[item].router });
                })
            }.width('100%')
            .direction(Direction.Rtl)
          }
        }, (item:number) => item.toString())
      }
    }
    .width('100%')
    .height('100%')
  }
}

class RouterData {
  router: string = "";
  name: string | Resource = "";
}