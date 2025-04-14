import os

from PIL import Image
import numpy as np

make_first_frame = 22
total_frames = 36
card_size = np.array([71, 95])
for image_index, image_name in enumerate(os.listdir("4")):
    image_path = os.path.join("4", image_name)
    image = Image.open(image_path).convert("RGBA")
    image_size = np.array(image.size)

    slack = (card_size - image_size) / 2
    slack_the_other_way = np.ceil(slack)
    slack = np.floor(slack)
    crop_size = list(-slack) + list(image_size+slack_the_other_way)
    print(crop_size)

    image = image.crop(crop_size)
    new_image = Image.new("RGBA", image.size)
    image_data = image.load()
    new_image_data = new_image.load()
    for x in range(image.width):
        for y in range(image.height):
            any_adjacent_transparency = False
            any_adjacent_solid = False
            for offset_x, offset_y in [
                (1,  0),
                (-1, 0),
                (0,  1),
                (0, -1),
            ]:
                to_check = (x+offset_x, y+offset_y)
                try:
                    any_adjacent_transparency = any_adjacent_transparency or image_data[to_check][3] == 0
                    any_adjacent_solid        = any_adjacent_solid        or image_data[to_check][3] == 255
                except IndexError:
                    continue

            if image_data[(x, y)][3] == 255 and any_adjacent_transparency:
                new_image_data[(x, y)] = (79, 99, 103, 255)
            elif image_data[(x, y)][3] == 0 and any_adjacent_solid:
                new_image_data[(x, y)] = (222, 245, 250, 255)
            else:
                new_image_data[(x, y)] = image_data[(x, y)]
    print("out to "+f"{(image_index+make_first_frame)%total_frames:03}.png")
    new_image.save(os.path.join("5", f"{(image_index-make_first_frame)%total_frames:03}.png"))