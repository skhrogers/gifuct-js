/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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
import fs from '@ohos.file.fs';
export class FileUtils {
    static readonly SEPARATOR: string = '/'
    private static sInstance: FileUtils
    base64Str: string = ''

    private constructor() {
    }

    /**
     * 单例实现FileUtils类
     */
    public static getInstance(): FileUtils {
        if (!this.sInstance) {
            this.sInstance = new FileUtils();
        }
        return this.sInstance;
    }

    /**
     * 新建文件
     *
     * @param path 文件绝对路径及文件名
     * @return number 文件句柄id
     */
    createFile(path: string): number {
        return fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).fd
    }

    /**
     * 删除文件
     *
     * @param path 文件绝对路径及文件名
     */
    deleteFile(path: string): void {
        try {
            let fileExist = fs.accessSync(path);
            if(fileExist) {
                fs.unlinkSync(path);
            }
        }catch (err){
            console.log("FileUtils deleteFile Method has error, err msg="+err.message + " err code="+err.code);
        }
    }

    /**
     * 拷贝文件
     *
     * @param src 文件绝对路径及文件名
     * @param dest 拷贝到对应的路径
     */
    copyFile(src: string, dest: string) {
        try {
            fs.copyFileSync(src, dest);
        } catch (err) {
            console.log("FileUtils copyFile Method has error, err msg=" + err.message + " err code=" + err.code);
        }
    }

    /**
     * 异步拷贝文件
     *
     * @param src 文件绝对路径及文件名
     * @param dest 拷贝到对应的路径
     */
    async copyFileAsync(src: string, dest: string): Promise<void> {
        try {
            await fs.copyFile(src, dest);
        } catch (err) {
            console.log("FileUtils copyFileAsync Method has error, err msg=" + err.message + " err code=" + err.code);
        }
    }

    /**
     * 清空已有文件数据
     *
     * @param path 文件绝对路径
     */
    clearFile(path: string): number {
        return fs.openSync(path, fs.OpenMode.TRUNC).fd
    }

    /**
     * 向path写入数据
     *
     * @param path 文件绝对路径
     * @param content 文件内容
     */
    writeData(path: string, content: ArrayBuffer | string) {
        try {
            let fd = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).fd
            let stat = fs.statSync(path)
            fs.writeSync(fd, content, { offset: stat.size })
            fs.closeSync(fd)
        } catch (err) {
            console.log("FileUtils writeData Method has error, err msg=" + err.message + " err code=" + err.code);
        }
    }

    /**
     * 异步向path写入数据
     *
     * @param path 文件绝对路径
     * @param content 文件内容
     */
    async writeDataAsync(path: string, content: ArrayBuffer | string): Promise<void> {
        try {
            let fd = (await fs.open(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)).fd
            let stat = await fs.stat(path)
            await fs.write(fd, content, { offset: stat.size })
            await fs.close(fd)
        } catch (err) {
            console.log("FileUtils writeDataAsync Method has error, err msg=" + err.message + " err code=" + err.code);
        }
    }

    /**
     * 判断path文件是否存在
     *
     * @param path 文件绝对路径
     */
    exist(path: string): boolean {
        try {
            let stat = fs.statSync(path)
            return stat.isFile()
        } catch (e) {
            console.error("FileUtils exist e " + e)
            return false
        }
    }

    /**
     * 向path写入数据
     *
     * @param path 文件绝对路径
     * @param data 文件内容
     */
    writeNewFile(path: string, data: ArrayBuffer | string) {
        this.createFile(path)
        this.writeFile(path, data)
    }

    /**
     * 向path写入数据
     *
     * @param path 文件绝对路径
     * @param data 文件内容
     */
    async writeNewFileAsync(path: string, data: ArrayBuffer | string): Promise<void> {
        try {
            let fd = (await fs.open(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)).fd
            await fs.truncate(fd)
            await fs.write(fd, data)
            await fs.fsync(fd)
            await fs.close(fd)
        } catch (err) {
            console.log("FileUtils writeNewFileAsync Method has error, err msg=" + err.message + " err code=" + err.code);
        }
    }

    /**
     * 获取path的文件大小
     *
     * @param path 文件绝对路径
     */
    getFileSize(path: string): number {
        try {
            let stat = fs.statSync(path)
            return stat.size
        } catch (e) {
            console.error("FileUtils getFileSize e " + e)
            return -1
        }
    }

    /**
     * 读取路径path的文件
     *
     * @param path 文件绝对路径
     */
    readFile(path: string): ArrayBuffer {
        let buf;
        try {
            let fd = fs.openSync(path, fs.OpenMode.READ_WRITE).fd;
            let length = fs.statSync(path).size;
            buf = new ArrayBuffer(length);
            fs.readSync(fd, buf);
        } catch (err) {
            console.log("FileUtils readFile Method has error, err msg=" + err.message + " err code=" + err.code);
        }
        return buf
    }

    /**
     * 读取路径path的文件
     *
     * @param path 文件绝对路径
     */
    async readFileAsync(path: string): Promise<ArrayBuffer> {
        let buf;
        try {
            let stat = await fs.stat(path);
            let fd = (await fs.open(path, fs.OpenMode.READ_WRITE)).fd;
            let length = stat.size;
            buf = new ArrayBuffer(length);
            await fs.read(fd, buf);
        } catch (err) {
            console.log("FileUtils readFileAsync Method has error, err msg=" + err.message + " err code=" + err.code);
        }
        return buf
    }

    /**
     * 创建文件夹
     *
     * @param path 文件夹绝对路径，只有是权限范围内的路径，可以生成
     * @param recursive
     */
    createFolder(path: string, recursive?: boolean) {
        try {
            if (recursive) {
                if (!this.existFolder(path)) {
                    let lastInterval = path.lastIndexOf(FileUtils.SEPARATOR)
                    if (lastInterval == 0) {
                        return
                    }
                    let newPath = path.substring(0, lastInterval)
                    this.createFolder(newPath, true)
                    if (!this.existFolder(path)) {
                        fs.mkdirSync(path)
                    }
                }
            } else {
                if (!this.existFolder(path)) {
                    fs.mkdirSync(path)
                }
            }
        } catch (err) {
            console.log("FileUtils createFolder Method has error, err msg=" + err.message + " err code=" + err.code);
        }
    }

    /**
     * 判断文件夹是否存在
     *
     * @param path 文件夹绝对路径
     */
    existFolder(path: string): boolean {
        try {
            let stat = fs.statSync(path)
            return stat.isDirectory()
        } catch (e) {
            console.error("FileUtils folder exist e " + e)
            return false
        }
    }

    private writeFile(path: string, content: ArrayBuffer | string) {
        try {
            let fd = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).fd
            fs.truncateSync(fd)
            fs.writeSync(fd, content)
            fs.fsyncSync(fd)
            fs.closeSync(fd)
        } catch (err) {
            console.log("FileUtils readFileAsync Method has error, err msg=" + err.message + " err code=" + err.code);
        }
    }

    /**
     * 将Uint8Array转为arraybuffer
     * @param array Uint8Array
     */
    typedArrayToBuffer(array: Uint8Array): ArrayBuffer {
        return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset)
    }
}