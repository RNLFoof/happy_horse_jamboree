
from typing import List

from PIL import Image

from oklch.src.oklch import OKLCH

parts = {
    "lips": int(0/360*255),  # (255, 0, 0),
    "hat_sides": int(60/360*255),  # (255, 255, 0),
    "eye": int(120/360*255),  # (0, 255, 0),
    "hat_middle": int(180/360*255),  # (0, 255, 255),
    "mane": int(240/360*255),  # (0, 0, 255),
}

bonus_hues = {
    "chips": 240,
    "mult": 0,
    "money": 30,
    "luck": 120,
}
bonus_hues = {k: int(v/360*255) for k, v in bonus_hues.items()}

new_saturation = round(66.4/100*255)
new_value = round(99.2/100*255)
new_secondary_value = round(67.2/100*255)

base_red = OKLCH(0.7, 0.1, 285)

def get_colors_for_these_bonuses(bonuses: List[str]):
    print("HORSE: ", bonuses)
    if len(set(bonuses)) == 1:
        the_only_bonus = bonuses[0]
        base_hue = bonus_hues[the_only_bonus]

        hue_offset = 5
        new_primary_hue   = (base_hue + hue_offset) % 255
        new_secondary_hue = (base_hue - hue_offset) % 255

        primary_color   = (new_primary_hue, new_saturation, new_value)
        secondary_color = (new_secondary_hue, new_saturation, new_secondary_value)

        conversions = {
            parts["lips"]:       primary_color,
            parts["hat_sides"]:  secondary_color,
            parts["eye"]:        secondary_color,
            parts["hat_middle"]: primary_color,
            parts["mane"]:       secondary_color,
        }

        return conversions
    elif len(set(bonuses)) == 2:
        primary_bonus, _, secondary_bonus = sorted(bonuses, key=lambda x: bonuses.count(x), reverse=True)

        primary_hue   = bonus_hues[primary_bonus]
        secondary_hue = bonus_hues[secondary_bonus]

        primary_color   = (primary_hue, new_saturation, new_value)
        secondary_color = (secondary_hue, new_saturation, new_value)

        conversions = {
            parts["lips"]: primary_color,
            parts["hat_sides"]: secondary_color,
            parts["eye"]: secondary_color,
            parts["hat_middle"]: primary_color,
            parts["mane"]: secondary_color,
        }

        return conversions
    return None

def color_a_horse(conversions):
    # conversions = {
    #     parts["lips"]:       bonus_hues["chips"],
    #     parts["hat_sides"]:  bonus_hues["chips"],
    #     parts["eye"]:        bonus_hues["chips"],
    #     parts["hat_middle"]: bonus_hues["chips"],
    #     parts["mane"]:       bonus_hues["chips"],
    # }

    horse_image = Image.open("horse.png")
    horse_image_hsv = horse_image.convert("HSV")
    horse_image_hsv_data = horse_image_hsv.load()
    for x in range(horse_image.width):
        for y in range(horse_image.height):
            if horse_image_hsv_data[x, y][0] not in conversions:
                continue
            if horse_image_hsv_data[x, y][1] != 255:
                continue
            if horse_image_hsv_data[x, y][2] != 255:
                continue
            horse_image_hsv_data[x, y] = conversions[horse_image_hsv_data[x, y][0]]
    horse_image_modified = horse_image_hsv.convert("RGBA")
    horse_image_modified.putalpha(horse_image.getchannel("A"))
    horse_image_modified.show()

def color_many_horses():
    for         bonus_1_index, bonus_1 in enumerate(list(bonus_hues.keys())                ):
        for     bonus_2_index, bonus_2 in enumerate(list(bonus_hues.keys())[bonus_1_index:]):
            for bonus_3_index, bonus_3 in enumerate(list(bonus_hues.keys())[bonus_2_index:]):
                colors_for_these_bonuses = get_colors_for_these_bonuses([
                    bonus_1,
                    bonus_2,
                    bonus_3,
                ])
                if not colors_for_these_bonuses:
                    continue
                color_a_horse(colors_for_these_bonuses)



# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    color_many_horses()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
