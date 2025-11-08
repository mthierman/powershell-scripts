# ffmpeg -i input.mp4 -vcodec libx265 -crf 28 output.mp4
# ffmpeg -i input.mp4 output.webm

# GOOD ONE!
# ffmpeg -i input2.mp4 -s 720x480 -vcodec libx265 -crf 28 output.mp4

# TIMESTAMPED!
# ffmpeg -ss 00:05:30 -to 00:06:30 -i input2.mp4 -s 720x480 -vcodec libx265 -crf 28 output.mp4

# FITS IN DISCORD
# ffmpeg -ss 00:05:30 -to 00:06:30 -i input2.mp4 -s 720x480 -crf 32 output.mp4

# 30 SECONDS CLIP UNDER 10MB FOR DISCORD
# ffmpeg -ss 00:06:30 -to 00:07:00 -i input2.mp4 -s 720x480 -crf 28 output.mp4

ffmpeg -ss 00:06:30 -to 00:07:00 -i input2.mp4 -s 720x480 output.webm
