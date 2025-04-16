

import { _default } from '../../../3rd_party/jsbinaryschemaparser/lib/schemas/gif'
import { conditional, loop, parse } from '../../../3rd_party/jsbinaryschemaparser/lib/index'
import {
  buildStream,
  peekByte,
  peekBytes,
  readArray,
  readBits,
  readByte,
  readBytes,
  readString,
  readUnsigned
} from '../../../3rd_party/jsbinaryschemaparser/lib/parsers/uint8'
import { deinterlace } from './deinterlace'
import { lzw } from './lzw'

var _gif = _interopRequireDefault(_default);

function _interopRequireDefault(obj) {
  return  { "default": obj };
}

var parseGIF = function parseGIF(arrayBuffer) {
  var byteData = new Uint8Array(arrayBuffer);
  return (parse)((buildStream)(byteData), _gif["default"]);
};

var generatePatch = function generatePatch(image) {
  var totalPixels = image.pixels.length;
  var patchData = new Uint8ClampedArray(totalPixels * 4);

  for (var i = 0; i < totalPixels; i++) {
    var pos = i * 4;
    var colorIndex = image.pixels[i];
    var color = image.colorTable[colorIndex] || [0, 0, 0];
    patchData[pos] = color[0];
    patchData[pos + 1] = color[1];
    patchData[pos + 2] = color[2];
    patchData[pos + 3] = colorIndex !== image.transparentIndex ? 255 : 0;
  }

  return patchData;
};

var decompressFrame = function decompressFrame(frame, gct, buildImagePatch) {
  if (!frame.image) {
    console.warn('gif frame does not have associated image.');
    return;
  }

  var image = frame.image; // get the number of pixels

  var totalPixels = image.descriptor.width * image.descriptor.height; // do lzw decompression

  var pixels = lzw(image.data.minCodeSize, image.data.blocks, totalPixels); // deal with interlacing if necessary

  if (image.descriptor.lct.interlaced) {
    pixels = deinterlace(pixels, image.descriptor.width);
  }

  var resultImage = {
    pixels: pixels,
    dims: {
      top: frame.image.descriptor.top,
      left: frame.image.descriptor.left,
      width: frame.image.descriptor.width,
      height: frame.image.descriptor.height
    }
  }; // color table

  if (image.descriptor.lct && image.descriptor.lct.exists) {
    resultImage.colorTable = image.lct;
  } else {
    resultImage.colorTable = gct;
  } // add per frame relevant gce information


  if (frame.gce) {
    resultImage.delay = (frame.gce.delay || 10) * 10; // convert to ms

    resultImage.disposalType = frame.gce.extras.disposal; // transparency

    if (frame.gce.extras.transparentColorGiven) {
      resultImage.transparentIndex = frame.gce.transparentColorIndex;
    }
  } // create canvas usable imagedata if desired


  if (buildImagePatch) {
    resultImage.patch = generatePatch(resultImage);
  }

  return resultImage;
};


var decompressFrames = function decompressFrames(parsedGif, buildImagePatches) {
  return parsedGif.frames.filter(function (f) {
    return f.image;
  }).map(function (f) {
    return decompressFrame(f, parsedGif.gct, buildImagePatches);
  });
};

export {decompressFrames,decompressFrame,parseGIF,generatePatch}