#!/usr/bin/env python3
import sys, os, time
from manga_ocr import MangaOcr
import subprocess

mocr = MangaOcr()
watch_path = "/tmp/ocr-input.png"
done_path = "/tmp/ocr-done"

print("manga-ocr daemon ready", flush=True)
while True:
    if os.path.exists(watch_path) and not os.path.exists(done_path):
        text = mocr(watch_path)
        print("OCR result:", text, flush=True)
        subprocess.run(["wl-copy", text])
        open(done_path, 'w').close()
    time.sleep(0.2)
