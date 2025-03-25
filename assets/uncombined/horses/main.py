import cmath
import os
import re
from colorsys import rgb_to_hsv, hsv_to_rgb
from math import pi, e
from typing import List, Dict, Tuple

from PIL import Image
from PIL.ImageDraw import ImageDraw

from oklch.src.oklch import OKLCH, RGB

basic_colors: Dict[str, Tuple[int, int, int]] = {
    "red":    (255, 0,   0),
    "orange": (255, 128, 0),
    "yellow": (255, 255, 0),
    "green":  (0,   255, 0),
    "cyan":   (0,   255, 255),
    "blue":   (0,   0,   255),
}

parts: Dict[str, Tuple[int, int, int]] = {
    "lips":       basic_colors["red"],
    "hat_sides":  basic_colors["yellow"],
    "eye":        basic_colors["green"],
    "hat_middle": basic_colors["cyan"],
    "mane":       basic_colors["blue"],
}

bonus_colors: Dict[str, Tuple[int, int, int]] = {
    "chips": basic_colors["blue"],
    "mult":  basic_colors["red"],
    "money": basic_colors["yellow"],
    "luck":  basic_colors["green"],
}

new_saturation = round(66.4/100*255)
new_value = round(99.2/100*255)
new_secondary_value = round(67.2/100*255)

base_red = (253, 95, 85)

def rgb_object_to_tuple(rgb):
    return (
        rgb.r,
        rgb.g,
        rgb.b,
    )

# def hue_to_complex_number(hue):
#     return cmath.rect(1, (hue/360*pi*2)-pi)
    # return e ** ((hue / 360) * 1j * pi * 2)

def hue_difference(a, b):
    a = a % 360
    b = b % 360
    potentials = [
        a - b,
        a - (b + 360),
        a - (b - 360),
    ]
    potentials.sort(key=lambda x: abs(x))
    return potentials[0]

assert(hue_difference(0, 0   ) == 0)
assert(hue_difference(45, 315) == 90)
assert(hue_difference(315, 45) == -90)

def impose_hue(source_rgb, target_rgb, hue_offset=0.0):
    target_lch = RGB(*target_rgb).to_OKLCH()
    target_lch.h = RGB(*source_rgb).to_OKLCH().h + hue_offset
    target_rgb = target_lch.to_RGB()
    target_rgb = rgb_object_to_tuple(target_rgb)
    return target_rgb
def get_colors_for_these_bonuses(bonuses: List[str]):
    print("HORSE: ", bonuses)
    if len(set(bonuses)) == 1:
        the_only_bonus = bonuses[0]
        bonus_color = bonus_colors[the_only_bonus]

        # how_much_of_the_color_wheel_it_spans = 1/12
        # hue_offset = how_much_of_the_color_wheel_it_spans/2*360
        hue_offset = 30
        # new_primary_hue   = (base_hue + hue_offset) % 1
        # new_secondary_hue = (base_hue - hue_offset) % 1

        primary_color   = impose_hue(bonus_color, base_red, hue_offset)
        secondary_color = impose_hue(bonus_color, base_red, -hue_offset)

        conversions = {
            parts["lips"]:       primary_color,
            parts["hat_sides"]:  secondary_color,
            parts["eye"]:        secondary_color,
            parts["hat_middle"]: primary_color,
            parts["mane"]:       secondary_color,
        }

        return conversions
    elif len(set(bonuses)) == 2:
        # The idea is that uhm
        # Okay imagine a color wheel
        # ....actually I don't wanna explain. check assets\uncombined\jokers\Horse\brainstorm.xcf and figure it out lol
        primary_bonus, _, secondary_bonus = sorted(bonuses, key=lambda x: bonuses.count(x), reverse=True)

        primary_bonus_color   = bonus_colors[primary_bonus]
        secondary_bonus_color = bonus_colors[secondary_bonus]

        # HSV hues and OKLCH hues aren't the same and HSV is better *specifically* for complementary colors aaa I'm gonna die
        primary_hue   = rgb_to_hsv(*[x/255 for x in primary_bonus_color])  [0] * 360
        secondary_hue = rgb_to_hsv(*[x/255 for x in secondary_bonus_color])[0] * 360

        original_primary_hue = primary_hue
        original_secondary_hue = secondary_hue

        hue_a = primary_hue + hue_difference(secondary_hue+180, primary_hue) / 2
        hue_b = hue_a + 180

        a_dif = abs(hue_difference(primary_hue, hue_a))
        b_dif = abs(hue_difference(primary_hue, hue_b))
        if a_dif < b_dif or True:
            primary_hue = hue_a
        else:
            primary_hue = hue_b
        secondary_hue = (primary_hue + 180) % 360

        color_with_primary_hue =   RGB(*[round(x) * 255 for x in hsv_to_rgb((primary_hue   / 360) % 1, 1, 1)]).to_OKLCH()
        color_with_secondary_hue = RGB(*[round(x) * 255 for x in hsv_to_rgb((secondary_hue / 360) % 1, 1, 1)]).to_OKLCH()

        base_red_oklch  = RGB(*base_red).to_OKLCH()
        primary_color   = rgb_object_to_tuple(OKLCH(base_red_oklch.l, base_red_oklch.c, color_with_primary_hue.h  ).to_RGB())
        secondary_color = rgb_object_to_tuple(OKLCH(base_red_oklch.l, base_red_oklch.c, color_with_secondary_hue.h).to_RGB())

        dbw = 128
        debug_image = Image.new("HSV", (dbw, dbw), (0, 0, 255))
        draw = ImageDraw(debug_image)
        # draw.ellipse((0,0,dbw,dbw))

        drawn = []
        layers = 25
        for angle in range(360):
            def xy_for_layer(layer):
                distance = dbw / 2 / layers * (layers-layer)
                its_here = cmath.rect(distance, (angle / 360 * pi * 2) - pi)
                x, y = its_here.real + dbw / 2, its_here.imag + dbw / 2
                return x, y

            hue = round(angle/360*255)
            fill = (hue, 255, 255)
            draw.point(xy_for_layer(0), fill)

            # shoot_me = RGB(*[round(x) * 255 for x in hsv_to_rgb([y/255 for y in fill]).to_OKLCH()
            shoot_me = rgb_object_to_tuple(OKLCH(1, 1, (hue+60)%360).to_RGB())
            shoot_me = rgb_to_hsv(*[x/255 for x in shoot_me])
            shoot_me = tuple([round(x*255) for x in shoot_me])
            draw.point(xy_for_layer(1), shoot_me)

            for mark_index, (mark_name, mark) in enumerate([
                ("1", primary_hue),
                ("2", secondary_hue),
                ("or1", original_primary_hue),
                ("ac1", original_primary_hue+180), # ac -> across
                ("or2", original_secondary_hue),
                ("ac2", original_secondary_hue+180),
            ]):
                if round(angle/5) == round((mark%360)/5):
                    at = xy_for_layer(mark_index + 2)
                    draw.line((dbw//2, dbw//2, *at), (32 * mark_index, 0, 192))
                    draw.point(at, (32 * mark_index, 255, 128))
                    text = mark_name
                    if text not in drawn:
                        draw.text(at, text)
                        drawn.append(text)
        debug_image.show()

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
    horse_image_rgb = horse_image.convert("RGB")
    horse_image_rgb_data = horse_image_rgb.load()
    for x in range(horse_image.width):
        for y in range(horse_image.height):
            if horse_image_rgb_data[x, y] not in conversions:
                continue
            horse_image_rgb_data[x, y] = conversions[horse_image_rgb_data[x, y]]
    horse_image_modified = horse_image_rgb.convert("RGBA")
    horse_image_modified.putalpha(horse_image.getchannel("A"))
    # horse_image_modified.show()

    return horse_image_modified

def color_many_horses():
    for         bonus_1_index, bonus_1 in enumerate(list(bonus_colors.keys())):
        for     bonus_2_index, bonus_2 in enumerate(list(bonus_colors.keys())[bonus_1_index:]):
            for bonus_3_index, bonus_3 in enumerate(list(bonus_colors.keys())[bonus_2_index:]):
                these_bonuses = [
                    bonus_1,
                    bonus_2,
                    bonus_3,
                ]
                colors_for_these_bonuses = get_colors_for_these_bonuses(these_bonuses)
                if not colors_for_these_bonuses:
                    continue
                horse = color_a_horse(colors_for_these_bonuses)
                horse_filename = "".join(these_bonuses)

                # Debuggy
                draw = ImageDraw(horse)
                draw.text((0, 0), "".join([re.sub("[aeiou]", "", s).title() for s in these_bonuses]), "red")

                if not os.path.exists(horse_filename):
                    os.mkdir(horse_filename)
                horse.save(f"{horse_filename}/{horse_filename}.png")



# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    color_many_horses()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
