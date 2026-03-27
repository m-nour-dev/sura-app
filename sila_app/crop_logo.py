from PIL import Image, ImageDraw

def process_logo():
    img = Image.open('assets/icon/app_icon.png').convert('RGBA')
    width, height = img.size
    new_img = Image.new('RGBA', (width + 2, height + 2), (255, 255, 255, 255))
    new_img.paste(img, (1, 1))
    ImageDraw.floodfill(new_img, (0, 0), (255, 255, 255, 0), thresh=20)
    img = new_img.crop((1, 1, width + 1, height + 1))
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
    img.save('assets/images/app_logo_cropped.png', 'PNG')

process_logo()
print('Done cropped logo to assets/images/app_logo_cropped.png')