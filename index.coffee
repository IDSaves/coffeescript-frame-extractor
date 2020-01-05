fs = require "fs"
path = require "path"
FFmpeg = require "fluent-ffmpeg"
Sharp = require "sharp"
pngFileStream = require "png-file-stream"

GIFEncoder = require "gifencoder"
encoder = new GIFEncoder 320, 240

arr = fs.readdirSync "./input"


generateGif = (video) ->
    pngFileStream("./output/Output #{video}/tn_?_resized.png")
        .pipe(encoder.createWriteStream({ repeat: 0, delay: 500, quality: 10 }))
        .pipe(fs.createWriteStream("./output/Output #{video}/animated.gif"))
        .on("finish", () -> 
            console.log "Gif generated" 
        )

resizeScreenshots = (video) -> 
    for i in [1..5]
        console.log "output/Output #{video}/tn_#{i}.png"
        Sharp(path.resolve(__dirname, "output/Output #{video}/tn_#{i}.png"))
            .resize(320, 240)
            .toFile(path.resolve(__dirname, "output/Output #{video}/tn_#{i}_resized.png"))
    generateGif(video)

saveScreens = (video) ->
    new FFmpeg({source: path.resolve(__dirname, "input/#{video}")})
        .takeScreenshots(5, "./output/Output #{video}")
        .on("end", () ->
            resizeScreenshots(video)
        )


for video in arr
    saveScreens(video)