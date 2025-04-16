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

import { FileUtils } from './FileUtils'
import loadRequest from '@ohos.request';
import { SparkMD5 }   from '../../3rd_party/sparkmd5/spark-md5'

export class ResourceLoader {
    // 下载文件夹临时存储地址
    private static readonly downloadFolder: string = 'gifDownloadFolder'

    static loadMedia(resId: number, context): Promise<ArrayBuffer> {
        return context.resourceManager
            .getMediaContent(resId)
            .then(data => {
                let arrayBuffer = FileUtils.getInstance().typedArrayToBuffer(data);
                return arrayBuffer;
            })
    }

    static loadRawFile(filename: string, context) {
        return context.resourceManager
            .getRawFileContent(filename)
            .then(data => {
                let arrayBuffer = FileUtils.getInstance().typedArrayToBuffer(data);
                return arrayBuffer
            })
    }

    static loadString(path: string) {
        return FileUtils.getInstance().readFileAsync(path).then((successBuffer) => {
            return successBuffer;
        })
    }

    /**
     * 下载任务的处理
     * @param context 下载所需上下文
     * @param model 下载所需得数据源
     * @param onCompleteFunction 成功回调
     * @param onErrorFunction 失败回调
     */
    static downloadDataWithContext(context, model: Model, onCompleteFunction, onErrorFunction) {
        if (!model.url) {
            throw Error('DownloadClient model.url must not be null!')
        }

        let downloadConfig = this.prepareDownloadConfigWithContext(context, model);

        let loadTask = null;
        loadRequest.downloadFile(context, downloadConfig).then(downloadTask => {
            if (downloadTask) {
                loadTask = downloadTask;
                loadTask.on('progress', (receivedSize, totalSize) => {
                    let percent = Math.floor(((receivedSize * 1.0) / (totalSize * 1.0)) * 100) + "%"
                    if (model.progressCallBack) {
                        model.progressCallBack(percent);
                    }
                });

                loadTask.on('complete', () => {
                    let downloadPath = downloadConfig.filePath;
                    let arraybuffer = FileUtils.getInstance().readFile(downloadPath)
                    onCompleteFunction(arraybuffer);

                    FileUtils.getInstance().deleteFile(downloadPath);

                    this.setTaskOff(loadTask)
                    loadTask = null;
                    return arraybuffer;
                })

                loadTask.on('pause', () => {
                })

                loadTask.on('remove', () => {
                })

                loadTask.on('fail', (err) => {
                    onErrorFunction('DownloadClient Download task fail err =' + err)
                    if (loadTask) {
                        loadTask.remove().then(result => {
                            this.setTaskOff(loadTask)
                            loadTask = null
                        }).catch(err => {
                            loadTask = null;
                            console.log('DownloadClient Download task fail err =' + err);
                        })
                    }
                })

            } else {
                onErrorFunction('DownloadClient downloadTask dismiss!')
            }
        })
    }

    /**
     * 关闭下载任务得事件监听
     *
     * @param loadTask 下载任务句柄
     */
    static setTaskOff(loadTask) {
        loadTask.off('complete', () => {
        })

        loadTask.off('pause', () => {
        })

        loadTask.off('remove', () => {
        })

        loadTask.off('progress', () => {
        })

        loadTask.off('fail', () => {
        })
    }

    /**
     * 准备下载之前 预先处理文件和一些配置
     *
     * @param model 下载需要得数据源
     */
    private static prepareDownloadConfigWithContext(context, model: Model) {
        let filename = SparkMD5.hashBinary(model.url);
        let downloadFolder =
            context
                .filesDir + FileUtils.SEPARATOR + ResourceLoader.downloadFolder;
        let fullFilename = downloadFolder + FileUtils.SEPARATOR + filename;
        if (!FileUtils.getInstance().existFolder(downloadFolder)) {
            FileUtils.getInstance().createFolder(downloadFolder)
        }

        if (FileUtils.getInstance().exist(fullFilename)) {
            FileUtils.getInstance().deleteFile(fullFilename)
        }

        var downloadConfig = {
            url: model.url,
            filePath: fullFilename,
            // 允许计费流量下载
            enableMetered: true,
            header: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
            }
        };
        return downloadConfig;
    }
}

/**
 * 下载任务所需的数据源
 */
export interface Model {

    url: string;
    //  [0%,100%]
    progressCallBack?: (progressPercent: string) => void;

}


