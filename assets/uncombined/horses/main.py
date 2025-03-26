import cmath
import os
import re
from colorsys import rgb_to_hsv, hsv_to_rgb
from math import pi, e
from typing import List, Dict, Tuple

import numpy
from PIL import Image
from PIL.ImageDraw import ImageDraw

from oklch.src.oklch import OKLCH, RGB

basic_colors: Dict[str, Tuple[int, int, int]] = {
    "red": (255, 0, 0),
    "orange": (255, 128, 0),
    "yellow": (255, 255, 0),
    "green": (0, 255, 0),
    "cyan": (0, 255, 255),
    "blue": (0, 0, 255),
}

parts: Dict[str, Tuple[int, int, int]] = {
    "lips": basic_colors["red"],
    "hat_sides": basic_colors["yellow"],
    "eye": basic_colors["green"],
    "hat_middle": basic_colors["cyan"],
    "mane": basic_colors["blue"],
}

bonus_colors: Dict[str, Tuple[int, int, int]] = {
    "chips": basic_colors["blue"],
    "mult": basic_colors["red"],
    "money": basic_colors["yellow"],
    "luck": basic_colors["green"],
}

color_wheel_hsv_points = [
    # Basing it on https://louisem.com/wp-content/uploads/2022/08/12-color-wheel-1024x1024.jpg
    # Seems reasonable
    # (255, 0, 0),  # Red
    # (255, 128, 0),  # Orange
    # (255, 255, 0),  # Yellow
    # (0, 255, 0),  # Green
    # (0, 0, 255),  # Blue
    # (121, 30, 159),  # Violet, honestly the wheel not being dead on purple bugs me but whatever it looks nice

    # (255, 0, 0), # (254, 0, 2),  # red
    # (247, 82, 2),
    # (255, 142, 2),  # orange
    # (252, 205, 1),
    # (254, 242, 0),  # yellow
    # (135, 226, 61),
    # (36, 180, 82),  # green
    # (24, 141, 123),
    # (17, 95, 255), # blue
    # (102, 65, 243),
    # (121, 30, 159), # violet
    # (168, 50, 128),
]
for color_index, color in enumerate(color_wheel_hsv_points):
    color_wheel_hsv_points[color_index] = rgb_to_hsv(*[b / 255 for b in color])[0]
color_wheel_hsv_points.append(1) # So it loops
color_wheel_color_wheel_points = list(x / (len(color_wheel_hsv_points) - 1) for x in range(len(color_wheel_hsv_points))) # Programmers are great at naming things
print(color_wheel_hsv_points)
print(color_wheel_color_wheel_points)
class Hue:

    # hsv is the assumed color space
    def __init__(self, color_wheel_placement):
        self._color_wheel_placement = color_wheel_placement % 1

    def __add__(self, other):
        if type(other) is Hue:
            other = Hue.as_color_wheel_1()
        return Hue(other + self.as_color_wheel_1())

    def __sub__(self, other):
        return self + -other

    @classmethod
    def hsv_to_color_wheel(cls, hsv_hue):
        return numpy.interp(hsv_hue, color_wheel_hsv_points, color_wheel_color_wheel_points)

    @classmethod
    def color_wheel_to_hsv(cls, color_wheel_hue):
        return numpy.interp(color_wheel_hue, color_wheel_color_wheel_points, color_wheel_hsv_points)

    @classmethod
    def from_rgb_1(cls, rgb_1):
        hsv_hue = rgb_to_hsv(*rgb_1)[0]
        color_wheel_hue = cls.hsv_to_color_wheel(hsv_hue)
        return cls(color_wheel_hue)

    @classmethod
    def from_rgb_255(cls, rgb_255):
        return cls.from_rgb_1(cls.list_to_cycle_of(rgb_255, 1, original_cycle=255))

    def as_color_wheel_1(self):
        return self.as_color_wheel_with_cycle_of(1)

    def as_color_wheel_with_cycle_of(self, cycle_of):
        return self.number_to_cycle_of(self._color_wheel_placement, cycle_of)

    def as_hsv_hue_1(self):
        hsv_placement = self.color_wheel_to_hsv(self.as_color_wheel_1())
        return self.number_to_cycle_of(hsv_placement, 1)

    @classmethod
    def number_to_cycle_of(cls, number, cycle_of, original_cycle=1):
        # This used to have %1 in it, but actually!! Looping anything besides hue doesn't make sense
        output = (number/original_cycle) * cycle_of
        if cycle_of > 1:
            output = round(output)
        return output

    @classmethod
    def list_to_cycle_of(cls, lst, cycle_of, original_cycle=1):
        return tuple([cls.number_to_cycle_of(n, cycle_of, original_cycle) for n in lst])

    def as_hsv_hue_with_cycle_of(self, cycle_of):
        return self.number_to_cycle_of(self.as_hsv_hue_1(), cycle_of)

    def as_hsv_hue_255(self):
        return self.as_hsv_hue_with_cycle_of(255)

    def as_hsv_hue_360(self):
        return self.as_hsv_hue_with_cycle_of(360)

    # Generic, as in, the s and v just default to max
    def to_generic_1_rgb(self):
        return hsv_to_rgb(*self.to_generic_1_hsv())

    def to_generic_255_rgb(self):
        return self.list_to_cycle_of(self.to_generic_1_rgb(), 255)

    def to_generic_rgb_object(self):
        return RGB(self.to_generic_255_rgb())

    def to_generic_oklch(self):
        return RGB(*self.to_generic_255_rgb()).to_OKLCH()

    def to_generic_1_hsv(self):
        return self.as_hsv_hue_1(), 1, 1
    
    def to_generic_255_hsv(self):
        return self.list_to_cycle_of(self.to_generic_1_hsv(), 255)

def rgb_object_to_tuple(rgb):
    return (
        rgb.r,
        rgb.g,
        rgb.b,
    )

def print_assert(x):
    print(x)
    assert(x != False)
    return x

def print_assert_equals(x, y):
    print("Original:", x, "==", y, "?")
    if isinstance(x, float):
        x = round(x, 2) % 1
    if isinstance(y, float):
        y = round(y, 2) % 1
    print("\t", x, "==", y, "?")
    assert(x == y)
    return x


hsv_hue_green = 1/3
rgb_1_green = (0, 1, 0)
rgb_255_green = (0, 255, 0)
color_wheel_green = Hue.from_rgb_1(rgb_1_green).as_color_wheel_1()  # This *was* a flat 0.5 but like idk new colors are weird I'm making it circular and untestable lol
print("wow")
for x in range(6):
    print(f"x = {x}")
    print_assert_equals(Hue.color_wheel_to_hsv(color_wheel_color_wheel_points[x]), color_wheel_hsv_points[x])
    print_assert_equals(Hue.hsv_to_color_wheel(color_wheel_hsv_points[x]), color_wheel_color_wheel_points[x])
print("a")
print_assert_equals(Hue.from_rgb_255((255, 0, 0)).as_hsv_hue_255(), 0)
print_assert_equals((Hue(color_wheel_green).as_color_wheel_1()), color_wheel_green)
# print_assert_equals(color_wheel_color_wheel_points[3], color_wheel_green)
# print_assert_equals(color_wheel_hsv_points[3], hsv_hue_green)
print_assert_equals(Hue.color_wheel_to_hsv(color_wheel_green), hsv_hue_green)
print("b")
print_assert_equals(Hue.hsv_to_color_wheel(hsv_hue_green), color_wheel_green)
print_assert_equals(Hue(color_wheel_green).as_color_wheel_1(), color_wheel_green)
print_assert_equals(Hue(color_wheel_green).as_hsv_hue_1(), hsv_hue_green)
print("c")
print_assert_equals(Hue(color_wheel_green).as_hsv_hue_360(), 120)
print_assert_equals(Hue.from_rgb_1(rgb_1_green).as_color_wheel_1(), color_wheel_green)
print_assert_equals(Hue.list_to_cycle_of(rgb_255_green, 1, original_cycle=255), rgb_1_green)
print("d")
print_assert_equals(Hue.from_rgb_255(rgb_255_green).as_color_wheel_1(), color_wheel_green)
print_assert_equals(Hue.from_rgb_255((0, 255, 0)).as_hsv_hue_360(), 120)
print_assert_equals(Hue.from_rgb_255((0, 255, 0)).to_generic_255_rgb(), (0, 255, 0))
print_assert_equals(Hue.from_rgb_255((255, 255, 0)).to_generic_255_rgb(), (255, 255, 0))

boutta = Hue.from_rgb_255(
                (255, 0, 0)
            ).to_generic_255_rgb()
print(boutta)
assert(boutta == (255, 0, 0))

# assert(
#     (
#             Hue.from_rgb_255(
#                 (255, 0, 0)
#             ) + 0.5
#     ).to_generic_255_rgb() == (0, 255, 0)
# )



new_saturation = round(66.4 / 100 * 255)
new_value = round(99.2 / 100 * 255)
new_secondary_value = round(67.2 / 100 * 255)

base_red = (253, 95, 85)




# def hue_to_complex_number(hue):
#     return cmath.rect(1, (hue/360*pi*2)-pi)
# return e ** ((hue / 360) * 1j * pi * 2)

def hue_distance(a: Hue, b: Hue):
    # originally I tried adding the angles before converting to floats, but like, that makes it loop lol
    potentials = [
        a.as_color_wheel_1() - (b.as_color_wheel_1()    ),
        a.as_color_wheel_1() - (b.as_color_wheel_1() + 1),
        a.as_color_wheel_1() - (b.as_color_wheel_1() - 1),
    ]
    potentials.sort(key=lambda x: abs(x))
    return potentials[0]


print_assert_equals(hue_distance(Hue(  0 / 360), Hue(  0 / 360)),   0 / 360)
print_assert_equals(hue_distance(Hue( 45 / 360), Hue(315 / 360)),  90 / 360)
print_assert_equals(hue_distance(Hue(315 / 360), Hue( 45 / 360)), -90 / 360)


def impose_hue(source_rgb, target_rgb, hue_offset=0.0):
    target_lch = RGB(*target_rgb).to_OKLCH()
    target_lch.h = RGB(*source_rgb).to_OKLCH().h + hue_offset
    target_rgb = target_lch.to_RGB()
    target_rgb = rgb_object_to_tuple(target_rgb)
    return target_rgb


debug_image = None
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

        primary_color = impose_hue(bonus_color, base_red, hue_offset)
        secondary_color = impose_hue(bonus_color, base_red, -hue_offset)

        conversions = {
            parts["lips"]: primary_color,
            parts["hat_sides"]: secondary_color,
            parts["eye"]: secondary_color,
            parts["hat_middle"]: primary_color,
            parts["mane"]: secondary_color,
        }

        return conversions
    elif len(set(bonuses)) == 2:
        # The idea is that uhm
        # Okay imagine a color wheel
        # ....actually I don't wanna explain. check assets\uncombined\jokers\Horse\brainstorm.xcf and figure it out lol
        primary_bonus, _, secondary_bonus = sorted(bonuses, key=lambda x: bonuses.count(x), reverse=True)

        primary_bonus_color = bonus_colors[primary_bonus]
        secondary_bonus_color = bonus_colors[secondary_bonus]

        # HSV hues and OKLCH hues aren't the same and HSV is better *specifically* for complementary colors aaa I'm gonna die
        primary_hue = Hue.from_rgb_255(primary_bonus_color)
        secondary_hue = Hue.from_rgb_255(secondary_bonus_color)

        original_primary_hue = primary_hue
        original_secondary_hue = secondary_hue

        hue_a = primary_hue + hue_distance(secondary_hue + 0.5, primary_hue) / 2
        hue_b = hue_a + 0.5

        a_dif = abs(hue_distance(primary_hue, hue_a))
        b_dif = abs(hue_distance(primary_hue, hue_b))
        if a_dif < b_dif or True:
            primary_hue = hue_a
        else:
            primary_hue = hue_b
        secondary_hue = primary_hue + 0.5

        # color_with_primary_hue = primary_hue.to_generic_255_rgb()
        # color_with_secondary_hue = secondary_hue.to_generic_255_rgb()

        base_red_oklch = RGB(*base_red).to_OKLCH()
        primary_color = rgb_object_to_tuple(
            OKLCH(base_red_oklch.l, base_red_oklch.c, primary_hue.to_generic_oklch().h).to_RGB())
        secondary_color = rgb_object_to_tuple(
            OKLCH(base_red_oklch.l, base_red_oklch.c, secondary_hue.to_generic_oklch().h).to_RGB())

        dbw = 128
        global debug_image
        debug_image = Image.new("HSV", (dbw, dbw), (0, 0, 255))
        draw = ImageDraw(debug_image)
        # draw.ellipse((0,0,dbw,dbw))

        drawn = []
        layers = 25
        for angle in range(360):
            def xy_for_layer(layer):
                distance = dbw / 2 / layers * (layers - layer)
                its_here = cmath.rect(distance, (angle / 360 * pi * 2) - pi)
                x, y = its_here.real + dbw / 2, its_here.imag + dbw / 2
                return x, y

            hue = round(angle / 360 * 255)
            fill = (hue, 255, 255)
            #draw.point(xy_for_layer(0), fill)

            draw.point(xy_for_layer(1), Hue(angle / 360).to_generic_255_hsv())

            # shoot_me = RGB(*[round(x) * 255 for x in hsv_to_rgb([y/255 for y in fill]).to_OKLCH()
            shoot_me = rgb_object_to_tuple(OKLCH(1, 1, (hue + 60) % 360).to_RGB())
            shoot_me = rgb_to_hsv(*[x / 255 for x in shoot_me])
            shoot_me = tuple([round(x * 255) for x in shoot_me])
            #draw.point(xy_for_layer(2), shoot_me)

            for mark_index, (mark_name, mark) in enumerate([
                ("1", primary_hue.as_color_wheel_with_cycle_of(360)),
                ("2", secondary_hue.as_color_wheel_with_cycle_of(360)),
                ("or1", original_primary_hue.as_color_wheel_with_cycle_of(360)),
                ("ac1", (original_primary_hue + 0.5).as_color_wheel_with_cycle_of(360)),  # ac -> across
                ("or2", original_secondary_hue.as_color_wheel_with_cycle_of(360)),
                ("ac2", (original_secondary_hue + 0.5).as_color_wheel_with_cycle_of(360)),
            ]):
                if round(angle / 5) == round((mark / 5)):
                    at = xy_for_layer(mark_index + 4)
                    draw.line((dbw // 2, dbw // 2, *at), (32 * mark_index, 0, 192))
                    draw.point(at, (32 * mark_index, 255, 128))
                    text = mark_name
                    if text not in drawn:
                        draw.text(at, text)
                        drawn.append(text)
        # debug_image.show()

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
    for bonus_1_index, bonus_1 in enumerate(list(bonus_colors.keys())):
        for bonus_2_index, bonus_2 in enumerate(list(bonus_colors.keys())[bonus_1_index:]):
            for bonus_3_index, bonus_3 in enumerate(list(bonus_colors.keys())[bonus_2_index:]):
                global debug_image
                debug_image = Image.new("HSV", (128, 128), (0, 0, 255))
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
                horse_with_debug_image = Image.new("RGBA", (max(debug_image.width, horse.width), debug_image.height + horse.height))
                draw = ImageDraw(horse_with_debug_image)
                horse_with_debug_image.paste(debug_image, (0, 0))
                horse_with_debug_image.paste(horse, (0, debug_image.height))
                draw.text((0, 0), " ".join([re.sub("rsegeswrh", "", s).title() for s in these_bonuses]), "red")
                horse = horse_with_debug_image

                if not os.path.exists(horse_filename):
                    os.mkdir(horse_filename)
                horse.save(f"{horse_filename}/{horse_filename}.png")


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    color_many_horses()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
