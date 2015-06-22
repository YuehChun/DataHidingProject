from PIL import Image
import binascii
import optparse
import sys
import numpy
import datetime
import time
import pyimgur


def PostImgur(PATH,thisTitle):
	CLIENT_ID = "891e1beff3d3fb1"
	im = pyimgur.Imgur(CLIENT_ID)
	uploaded_image = im.upload_image(PATH, title=thisTitle)
	print "##### POST SUCCESS #####"
	print("Title : " + str(uploaded_image.title))
	print("Link : " + str(uploaded_image.link))
	print("Size : " + str(uploaded_image.size))
	print("Type : " + str(uploaded_image.type))


def PIL2array(img):
    return numpy.array(img.getdata(), numpy.uint8).reshape(img.size[1], img.size[0], 3)

def array2PIL(arr, size):
    mode = 'RGBA'
    arr = arr.reshape(arr.shape[0]*arr.shape[1], arr.shape[2])
    if len(arr[0]) == 3:
        arr = numpy.c_[arr, 255*numpy.ones((len(arr),1), numpy.uint8)]
    return Image.frombuffer(mode, size, arr.tostring(), 'raw', mode, 0, 1)

def rgb2hex(r, g, b):
	return '#{:02x}{:02x}{:02x}'.format(r, g, b)

def rgb2hexList(rgb):
	r,g,b,z = rgb
	return '#{:02x}{:02x}{:02x}'.format(r, g, b)

def hex2rgb(hexcode):
	return tuple(map(ord, hexcode[1:].decode('hex')))

def str2bin(message):
	binary = bin(int(binascii.hexlify(message), 16))
	return binary[2:]
	# return binary

def bin2str(binary):
	message = binascii.unhexlify('%x' % (int('0b'+binary,2)))
	return message

def encode(hexcode, digit):
	if hexcode[-1] in ('0','1', '2', '3', '4', '5'):
		hexcode = hexcode[:-1] + digit
		return hexcode
	else:
		return None

def decode(hexcode):
	if hexcode[-1] in ('0', '1'):
		return hexcode[-1]
	else:
		return None

def ShiftAEmbArray(tempArrObj,binary,digit):
	for Xa in range(0,3,1):
		for Xb in range(0,3,1):
			if not (Xa == 1 and Xb == 1):
				if tempArrObj[Xa][Xb] < 0:
					tempArrObj[Xa][Xb] = tempArrObj[Xa][Xb]-1
				elif tempArrObj[Xa][Xb] == 0 :
					if digit<len(binary):
						if binary[digit] == '0' :
							tempArrObj[Xa][Xb] = 0
						else:
							tempArrObj[Xa][Xb] = -1
						digit += 1
	return (tempArrObj,digit)

def DecoArray(tempArr):
	tempString = ""
	for a in range(0,3,1):
		for b in range(0,3,1):
			if not (a==1 and b==1):
				if tempArr[a][b] == 0:
					tempString += "0"
				elif tempArr[a][b] == -1 :
					tempString += "1"
	return tempString


def hideTsai(filename, message, mTitle):
	img = Image.open(filename)
	fNa=filename.split(".")[0]
	st = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S')
	if message == "":
		message = "test\ntest\ntest\n"

	binary2 = str2bin(message + "  " +st+ "  ") + '0000111100001111'
	# print binary2
	digit=0
	
	if img.mode in ('RGBA'):
		img = img.convert('RGBA')
		imgList = list(numpy.array(img))
		(imgWidth,imgHeight) = img.size
		tempArr = numpy.array([[0, 0, 0], [0, 0, 0], [0, 0, 0]])

		for y in range(0, len(imgList), 1):
			for x in range(0, len(imgList[y]), 1):
				if imgList[y][x][0]<2:
					imgList[y][x][0]=2
				elif imgList[y][x][0]>253:
					imgList[y][x][0]=253


		for y in range(1, len(imgList)-1, 3):
			for x in range(1, len(imgList[y])-1, 3):
				if not digit >= len(binary2):
					basicPix = int(imgList[y][x][0])
					tempArr[0][0] = int(imgList[y-1][x-1][0]) - basicPix
					tempArr[0][1] = int(imgList[y-1][x][0]) - basicPix
					tempArr[0][2] = int(imgList[y-1][x+1][0]) - basicPix
					tempArr[1][0] = int(imgList[y][x-1][0]) - basicPix
					tempArr[1][2] = int(imgList[y][x+1][0]) - basicPix
					tempArr[1][0] = int(imgList[y+1][x-1][0]) - basicPix
					tempArr[2][1] = int(imgList[y+1][x][0]) - basicPix
					tempArr[2][2] = int(imgList[y+1][x+1][0]) - basicPix
					(tempArr,digit) = ShiftAEmbArray(tempArr,binary2,digit)

					imgList[y-1][x-1][0] = tempArr[0][0] + basicPix
					imgList[y-1][x][0] = tempArr[0][1] + basicPix
					imgList[y-1][x+1][0] = tempArr[0][2] + basicPix

					imgList[y][x-1][0] = tempArr[1][0] + basicPix
					imgList[y][x+1][0] = tempArr[1][2] + basicPix
					
					imgList[y+1][x-1][0] = tempArr[2][0] + basicPix
					imgList[y+1][x][0] = tempArr[2][1] + basicPix
					imgList[y+1][x+1][0] = tempArr[2][2] + basicPix

		newData = []

		r, g, b = hex2rgb(rgb2hexList(imgList[y][x]))
		for y in range(0, len(imgList), 1):
			for x in range(0, len(imgList[y]), 1):
				r, g, b = hex2rgb(rgb2hexList(imgList[y][x]))
				newData.append((r, g, b, 255))


		img.putdata(newData)
		img.save(fNa + '_tsai.png', "PNG")
		PostImgur(fNa + '_tsai.png', mTitle)
		return "Completed!"
			
	return "Incorrect Image Mode, Couldn't Hide"

						
				

def retrTsai(filename):
	img = Image.open(filename)
	binary = ''
	
	if img.mode in ('RGBA'): 
		img = img.convert('RGBA')
		imgList = list(numpy.array(img))
		(imgWidth,imgHeight) = img.size

		tempArr = numpy.array([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
		embCode = ""
		for y in range(1, len(imgList)-1, 3):
			for x in range(1, len(imgList[y])-1, 3):
				if not '0000111100001111' in embCode:
					basicPix = int(imgList[y][x][0])

					tempArr[0][0] = int(imgList[y-1][x-1][0]) - basicPix
					tempArr[0][1] = int(imgList[y-1][x][0]) - basicPix
					tempArr[0][2] = int(imgList[y-1][x+1][0]) - basicPix

					tempArr[1][0] = int(imgList[y][x-1][0]) - basicPix
					tempArr[1][2] = int(imgList[y][x+1][0]) - basicPix

					tempArr[2][0] = int(imgList[y+1][x-1][0]) - basicPix
					tempArr[2][1] = int(imgList[y+1][x][0]) - basicPix
					tempArr[2][2] = int(imgList[y+1][x+1][0]) - basicPix
					embCode += DecoArray(tempArr)
		return bin2str(embCode[:embCode.index('0000111100001111')])
			
	return "Incorrect Image Mode, Couldn't Retrieve"

def hide(filename, message, mTitle):
	img = Image.open(filename)
	fNa=filename.split(".")[0]
	st = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S')
	binary = str2bin(message + "  " +st+ "  ") + '1111111111111110'
	if img.mode in ('RGBA'):
		img = img.convert('RGBA')
		datas = img.getdata()
		
		newData = []
		digit = 0
		temp = ''
		for item in datas:
			if (digit < len(binary)):
				newpix = encode(rgb2hex(item[0],item[1],item[2]),binary[digit])
				if newpix == None:
					newData.append(item)
				else:
					r, g, b = hex2rgb(newpix)
					newData.append((r,g,b,255))
					digit += 1
			else:
				newData.append(item)	
		img.putdata(newData)
		img.save(fNa + '_hide.png', "PNG")

		print PostImgur(fNa + '_hide.png', mTitle)
		return "Completed!"
			
	return "Incorrect Image Mode, Couldn't Hide"

						
				

def retr(filename):
	img = Image.open(filename)
	binary = ''
	
	if img.mode in ('RGBA'): 
		img = img.convert('RGBA')
		datas = img.getdata()
		
		for item in datas:
			digit = decode(rgb2hex(item[0],item[1],item[2]))
			if digit == None:
				pass
			else:
				binary = binary + digit
				if (binary[-16:] == '1111111111111110'):
					print "Success"
					return bin2str(binary[:-16])

		return bin2str(binary)
	return "Incorrect Image Mode, Couldn't Retrieve"



def Main():
	parser = optparse.OptionParser('usage %prog -e/-d/-t/-r <target file>')
	parser.add_option('-t', dest='hideTsai', type='string', help='target picture path to hide text')
	parser.add_option('-r', dest='retrTsai', type='string', help='target picture path to retrieve text')
	parser.add_option('-e', dest='hide', type='string', help='target picture path to hide text')
	parser.add_option('-d', dest='retr', type='string', help='target picture path to retrieve text')
	
	(options, args) = parser.parse_args()
	if (options.hide != None):
		text = raw_input("Enter a message to hide: ")
		title = raw_input("Enter the title: ")
		print hide(options.hide, text, title)
	elif (options.retr != None):
		print retr(options.retr)
	elif (options.hideTsai != None):
		print "#####   Tsai  Mode   #####"
		text = raw_input("Enter a message to hide: ")
		title = raw_input("Enter the title: ")
		print hideTsai(options.hideTsai, text, title)
	elif (options.retrTsai != None):
		print "#####   Tsai  Mode   #####"
		print retrTsai(options.retrTsai)
	else:
		print parser.usage
		exit(0)



if __name__ == '__main__':
	Main()