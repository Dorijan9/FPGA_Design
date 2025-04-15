from PIL import Image
import argparse #for argument parsing

parser = argparse.ArgumentParser()
parser.add_argument('filename')
args = parser.parse_args()

im = Image.open(args.filename, 'r')
width, height = im.size
pixel_values = list(im.getdata())

print("memory_initialization_radix=16;\nmemory_initialization_vector=")
for rgb in pixel_values:
	#divide each element by 16 in tuple
	pixel = tuple(int(t/16) for t in rgb)
	print(format(pixel[0],'x'),format(pixel[1],'x'),format(pixel[2],'x'),sep='')
