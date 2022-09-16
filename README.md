# Onlinescreensaver for Kindle

It's based on the work found here:
- https://www.mobileread.com/forums/showthread.php?t=236104

See the [original readme file](original-readme.txt).

I've modified those scripts to work on my Kindle 3 Keyboard.

I use it to fetch the image that shows my home dashboard. See this project:

https://github.com/bukowskiadam/kindle-page

## How it works

Idea is to wake up Kindle every X minutes based on the schedule to fetch the file.

It's the biggest difference between other implementations you can easily find on the internet.
Most of them disable the Kindle sleep and use cron to update the image.

Anyway, it's valuable to read how other people do it:

- https://github.com/mpetroff/kindle-weather-display (the same author as the base for those scripts)
- https://github.com/shatteredhaven/KindleWeatherDisplay
- https://github.com/dennisreimann/kindle-display

With those scripts, I get a pretty decent battery life and Kindle can work on a battery
for a long time.

## Installation

**My Kindle: Keyboard 3 WiFi**

https://www.mobileread.com/forums/showthread.php?t=225030

1. Root your Kindle
2. Install USB network
3. Install screensavers hack
4. Install MKK + KUAL
5. `cp bin/config.sh.sample bin/config.sh` and configure it
6. Copy those files to `/mnt/us/extensions/onlinescreensaver`
7. Using ssh check if updating works - `./bin/update.sh`
8. Enable it using ssh (`./bin/enable.sh`) or using KUAL launcher

**Important**

Because my Kindle is so old that curl does not support recent TLS/SSL I had
problems with downloading the file from Vercel. To fix that I cross-compiled
a little program with golang and copied the binary here.

https://github.com/bukowskiadam/fetch-file
