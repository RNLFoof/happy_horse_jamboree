import cmath
import os
import re
from colorsys import rgb_to_hsv, hsv_to_rgb
from dataclasses import dataclass
from math import pi, e
from typing import List, Dict, Tuple, Union

import numpy
from PIL import Image
from PIL.ImageDraw import ImageDraw

from oklch.src.oklch import OKLCH, RGB

debug_mode = False

# These are also used to replace the correct colors? so don't change them :)
basic_colors: Dict[str, Tuple[int, int, int]] = {
    "red": (255, 0, 0),
    "orange": (255, 127, 0),
    "yellow": (255, 255, 0),
    "green": (0, 255, 0),
    "cyan": (0, 255, 255),
    "blue": (0, 0, 255),
    "purple": (127, 0, 255),
    "magenta": (255, 0, 255),
}

parts: Dict[str, Tuple[int, int, int]] = {
    "upper_lip": basic_colors["red"],
    "lower_lip": basic_colors["yellow"],
    "hat_top": basic_colors["green"],
    "hat_middle": basic_colors["cyan"],
    "hat_bottom": basic_colors["blue"],
    "eye": basic_colors["purple"],
    "tuft": basic_colors["orange"],
    "mane": basic_colors["magenta"],
}

bonus_colors: Dict[str, Tuple[int, int, int]] = {
    "chips": basic_colors["blue"],
    "luck": basic_colors["green"],
    "money": basic_colors["yellow"],
    "mult": basic_colors["red"],
}

def negative_color(rgb):
    # This part is abouuuut what the actual game does?
    # max_value = max(rgb)
    # min_value = min(rgb)
    # new_rgb = []
    # green_highest = rgb[2] == max_value
    #
    # def invert(band):
    #     return max_value - (band - min_value)
    #
    # r, g, b = rgb
    # if green_highest:
    #     rgb = (
    #         invert(r),
    #         g,
    #         invert(b),
    #     )
    # else:
    #     rgb = (
    #         r,
    #         invert(g),
    #         b,
    #     )

    # for band in rgb:
    #     if band in [max_value, min_value]:
    #         new_rgb.append(band)
    #     else:
    #         new_rgb.append(max_value - (band - min_value))
    # new_rgb = tuple(new_rgb)
    # new_rgb = rgb

    # Only change the hue, since we're only trying to preserve information conserved by the hue
    old_oklch = RGB(*rgb).to_OKLCH()

    color_wheel_progress = Hue.oklch_hue_to_color_wheel_progress(old_oklch.h)
    new_oklch_hue = Hue.color_wheel_progress_to_oklch_hue(color_wheel_progress, negative_color_wheel)
    old_oklch.h = new_oklch_hue
    new_rgb = rgb_object_to_tuple(old_oklch.to_RGB())

    return new_rgb


def two_color_horse_palette(primary_color, secondary_color):
    return {
        parts["upper_lip"]: primary_color,
        parts["lower_lip"]: primary_color,
        parts["hat_top"]: secondary_color,
        parts["hat_middle"]: primary_color,
        parts["hat_bottom"]: secondary_color,
        parts["eye"]: secondary_color,
        parts["tuft"]: secondary_color,
        parts["mane"]: secondary_color,
    }

def three_color_horse_palette(primary_color, secondary_color, tertiary_color):
    return {
        parts["upper_lip"]: primary_color,
        parts["lower_lip"]: primary_color,
        parts["hat_top"]: secondary_color,
        parts["hat_middle"]: primary_color,
        parts["hat_bottom"]: secondary_color,
        parts["eye"]: secondary_color,
        parts["tuft"]: tertiary_color,
        parts["mane"]: tertiary_color,
    }

def horse_palette_debug_image(items: List[Tuple[str, "Hue"]]):
    global debug_image
    dbw = 128
    debug_image = Image.new("RGB", (dbw, dbw), (255, 255, 255))
    draw = ImageDraw(debug_image)
    # draw.ellipse((0,0,dbw,dbw))

    drawn = []
    layers = 25
    for angle in range(360):
        def xy_for_layer(layer):
            distance = dbw / 2 / layers * (layers - layer)
            its_here = cmath.rect(distance, (angle / 360 * pi * 2) - pi)
            x, y = -its_here.real + dbw / 2, its_here.imag + dbw / 2
            return x, y

        hue = round(angle / 360 * 255)
        fill = (hue, 255, 255)
        #draw.point(xy_for_layer(0), fill)

        draw.point(xy_for_layer(1), Hue(angle / 360).rgb_tuple())
        draw.point(xy_for_layer(2), Hue(angle / 360).rgb_tuple(color_wheel=negative_color_wheel))

        #draw.point(xy_for_layer(2), shoot_me)
        items.sort(key=lambda x: x[0])

        for mark_index, (mark_name, mark) in enumerate(items):
            mark = mark.color_wheel_progress(360)
            if round(angle) == round(mark):
                at = xy_for_layer(mark_index + 4)
                fill = Hue(mark_index / len(items)).rgb_tuple()
                draw.line((dbw // 2, dbw // 2, *at), fill)
                draw.point(at, (32 * mark_index, 255, 128))
                text = mark_name
                if text not in drawn:
                    draw.text(at, text, "black")
                    drawn.append(text)


class ColorWheel:
    def __init__(self, filename, force_upwards=False):
        self.points = []
        max_points = 12
        color_wheel_image = Image.open(filename).convert("RGBA")
        draw = ImageDraw(color_wheel_image)
        for point_index in range(max_points):
            distance = color_wheel_image.width / 4
            progress = point_index / max_points
            angle = progress * 360
            its_here = cmath.rect(distance, (angle / 360 * pi * 2) - pi)
            x, y = -its_here.real + color_wheel_image.width / 2, its_here.imag + color_wheel_image.width / 2
            print(x, y)
            r,g,b,a = color_wheel_image.getpixel((x, y))
            if a == 0:
                continue
            rgb = r, g, b
            self.points.append({
                "rgb": rgb,
                "color_wheel_progress": progress,
                "oklch": RGB(*rgb).to_OKLCH().to_OKLCH(),
                # "oklch_hue": RGB(*rgb).to_OKLCH().to_OKLCH().h,
            })
            draw.text((x,y), str(point_index))
        color_wheel_image.save("color_wheel_debug_image.png")
        # self.points[-1]["oklch"].h = 360
        # print(self.points)

        self.points.append({
            "rgb": self.points[0]["rgb"],
            "color_wheel_progress": 1,
            "oklch": self.points[0]["oklch"].to_RGB().to_OKLCH(),  #convert back and forth to make a copy
        })

        if force_upwards:
            previous_h = -10
            for point in self.points:
                while point["oklch"].h < previous_h:
                    point["oklch"].h += 360
                print(point["oklch"].h)
                previous_h = point["oklch"].h


default_color_wheel = ColorWheel("wheel_d.png", force_upwards=True)
negative_color_wheel = ColorWheel("wheel_neg.png")

class Hue:
    def __init__(self, color_wheel_placement):
        self._color_wheel_placement = color_wheel_placement % 1

    def __add__(self, other):
        if type(other) is Hue:
            other = Hue.color_wheel_progress()
        return Hue(other + self.color_wheel_progress())

    def __sub__(self, other):
        return self + -other

    @classmethod
    def oklch_hue_to_color_wheel_progress(cls, oklch_hue, color_wheel=None):
        color_wheel = color_wheel if color_wheel else default_color_wheel
        sorted_by_oklch_hue = sorted(color_wheel.points, key=lambda x: x["oklch"].h)
        return numpy.interp(oklch_hue,
                            [x["oklch"].h for x in sorted_by_oklch_hue],
                            [x["color_wheel_progress"] for x in sorted_by_oklch_hue],
                            #period=360
                            )

    @classmethod
    def color_wheel_progress_to_oklch_hue(cls, color_wheel_progress, color_wheel=None):
        return cls.color_wheel_progress_to_oklch(color_wheel_progress, color_wheel=color_wheel).h % 360
    @classmethod
    def color_wheel_progress_to_oklch(cls, color_wheel_progress, color_wheel=None):
        color_wheel = color_wheel if color_wheel else default_color_wheel
        sorted_by_color_wheel = sorted(color_wheel.points, key=lambda x: x["color_wheel_progress"])

        #ok let's get VERBOSE'
        return OKLCH(
            numpy.interp(color_wheel_progress,
                [x["color_wheel_progress"] for x in sorted_by_color_wheel],
                [x["oklch"].l for x in sorted_by_color_wheel],
                    #period=1
                ),
         numpy.interp(color_wheel_progress,
                [x["color_wheel_progress"] for x in sorted_by_color_wheel],
                [x["oklch"].c for x in sorted_by_color_wheel],
                    #period=1
                ),
         numpy.interp(color_wheel_progress,
                [x["color_wheel_progress"] for x in sorted_by_color_wheel],
                [x["oklch"].h for x in sorted_by_color_wheel],
                    #period=1
                ),
        )

    @classmethod
    def from_rgb(cls, rgb, original_cycle=255):
        rgb_255 = cls.list_to_cycle_of(rgb, 255, original_cycle)
        oklch = RGB(*rgb_255).to_OKLCH()
        oklch_hue = oklch.h
        return cls(cls.oklch_hue_to_color_wheel_progress(oklch_hue))

    def color_wheel_progress(self, cycle_of=1):
        return self.number_to_cycle_of(self._color_wheel_placement, cycle_of)

    def oklch_hue(self):
        return self.color_wheel_progress_to_oklch_hue(self.color_wheel_progress())

    def oklch(self, color_wheel=None):
        color_wheel = color_wheel if color_wheel else default_color_wheel
        return self.color_wheel_progress_to_oklch(self.color_wheel_progress(), color_wheel=color_wheel)

    def rgb_object(self, color_wheel=None):
        color_wheel = color_wheel if color_wheel else default_color_wheel
        return self.oklch(color_wheel=color_wheel).to_RGB()

    def rgb_tuple(self, cycle=255, color_wheel=None):
        color_wheel = color_wheel if color_wheel else default_color_wheel
        rgb = rgb_object_to_tuple(self.rgb_object(color_wheel=color_wheel))
        rgb = self.list_to_cycle_of(rgb, cycle, 255)
        return rgb

    @classmethod
    def number_to_cycle_of(cls, number, cycle_of, original_cycle=1):
        # This used to have %1 in it, but actually!! Looping anything besides hue doesn't make sense
        output = (number/original_cycle) * cycle_of
        if cycle_of > 1:
            output = round(output)
            output = min(output, cycle_of)
            output = max(output, 0)
        return output

    @classmethod
    def list_to_cycle_of(cls, lst, cycle_of, original_cycle=1):
        return tuple([cls.number_to_cycle_of(n, cycle_of, original_cycle) for n in lst])



    # Generic, as in, the s and v just default to max

    def to_generic_rgb_object(self):
        return self.to_generic_oklch_object().to_RGB()

    def to_generic_rgb_tuple(self):
        return rgb_object_to_tuple(self.to_generic_oklch_object().to_RGB())

    def to_generic_oklch_object(self):
        return OKLCH(1, 1, self.oklch_hue())

    def horse_palette_alongside(self, other_hues_if_any=None):
        if other_hues_if_any is None:
            other_hues_if_any = []

        if len(other_hues_if_any) == 0:
            return self.tapering_horse_palette()
            #return self.analogous_horse_palette()
        elif len(other_hues_if_any) == 1:
            other_hue = other_hues_if_any[0]
            dis = hue_distance(self, other_hue)
            print(dis)
            if abs(dis) >= 0.25:
                return self.complementary_horse_palette(other_hue)
            else:
                midhue = self - dis/2
                return midhue.analogous_horse_palette(
                    in_debug_also_list=[
                        ("ogin1", self),
                        ("ogin2", other_hue)
                    ],
                    primary_closer_to=self
                )
        else:
            return self.triple_horse_palette(*other_hues_if_any)

    def analogous_horse_palette(self, angle_difference=30, make_bigger_near_reds=True, in_debug_also_list=None,
                                primary_closer_to=None):
        if in_debug_also_list is None:
            in_debug_also_list = []
        if primary_closer_to is None:
            primary_closer_to = self
        else:
            in_debug_also_list.append(("aim", primary_closer_to))

        # idk the wheel just has colors close to get close together
        if make_bigger_near_reds and (self.color_wheel_progress() < 0.25 or self.color_wheel_progress() > 0.75):
            angle_difference *= 2

        the_two_hues = [
            self - angle_difference / 360 / 2,
            self + angle_difference / 360 / 2
        ]
        the_two_hues.sort(key=lambda hue: hue.color_wheel_progress())
        the_two_hues.sort(key=lambda hue:
            abs(hue_distance(
                primary_closer_to.to_generic_oklch_object().h / 360,
                hue.to_generic_oklch_object().h / 360,
            ))
        )
        the_two_hues.sort(key=lambda hue:
            abs(hue_distance(
                primary_closer_to.color_wheel_progress(),
                hue.color_wheel_progress(),
            ))
        )

        primary_hue, secondary_hue = tuple(the_two_hues)
        horse_palette_debug_image([
            ("in", self),
            ("out1", primary_hue),
            ("out2", secondary_hue),
        ] + in_debug_also_list)
        return two_color_horse_palette(primary_hue.rgb_tuple(), secondary_hue.rgb_tuple())

    def tapering_horse_palette(self, angle_difference=1/6/2/2, make_bigger_near_reds=False, in_debug_also_list=None):
        if in_debug_also_list is None:
            in_debug_also_list = []
        if make_bigger_near_reds and (self.color_wheel_progress() < 0.25 or self.color_wheel_progress() > 0.75):
            angle_difference *= 2
        potential_goals = [
            self + angle_difference * 2,
            self - angle_difference * 2,
        ]
        # potential_goals.sort(key=lambda hue: -hue.oklch().l)
        potential_goals.sort(key=lambda hue: -rgb_to_hsv(*hue.rgb_tuple(1))[2])
        goal = potential_goals[0]
        midpoint = self - hue_distance(self, goal) / 2

        horse_palette_debug_image([
            ("in", self),
            ("mid", midpoint),
            ("goal", goal),
        ] + in_debug_also_list)
        guys = [hue.oklch() for hue in [self, midpoint, goal]]
        for guy_index, guy in enumerate(guys):
            guy.l -= 1/12 * guy_index
            guy.l = max(0, guy.l)
        guys = [rgb_object_to_tuple(guy.to_RGB()) for guy in guys]

        return three_color_horse_palette(*guys)


    def complementary_horse_palette(self, secondary_hue: "Hue", in_debug_also_list=None):
        if in_debug_also_list is None:
            in_debug_also_list = []

        primary_hue = self

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

        primary_color = primary_hue.rgb_tuple()
        secondary_color = secondary_hue.rgb_tuple()

        horse_palette_debug_image([
            ("in1", original_primary_hue),
            ("in2", original_secondary_hue),
            ("out1", primary_hue),
            ("out2", secondary_hue),
        ] + in_debug_also_list)
        return two_color_horse_palette(primary_color, secondary_color)

    def triple_horse_palette(self, secondary_hue, tertiary_hue, sort=True, in_debug_also_list=None):
        if in_debug_also_list is None:
            in_debug_also_list = []
        the_guys = [self, secondary_hue, tertiary_hue]
        if sort:
            the_guys.sort(key=lambda hue: hue.color_wheel_progress())
        horse_palette_debug_image([
                                      (f"in{guy_index+1}", guy)
                                      for guy_index, guy in
                                      enumerate(the_guys)
                                  ] + in_debug_also_list)
        return three_color_horse_palette(*[hue.rgb_tuple() for hue in the_guys])




for official_color_rgb in [
    (252, 162, 0),  # Yellow
    (0, 156, 255),  # Blue
]:
    default_color_wheel.points.append({
        "rgb": official_color_rgb,
        "color_wheel_progress": Hue.from_rgb(official_color_rgb).color_wheel_progress(),
        "oklch": RGB(*official_color_rgb).to_OKLCH(),  # convert back and forth to make a copy
    })

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
color_wheel_green = Hue.from_rgb(rgb_1_green, 1).color_wheel_progress(1)  # This *was* a flat 0.5 but like idk new colors are weird I'm making it circular and untestable lol
print("wow")
# for x in range(6):
#     print(f"x = {x}")
#     print_assert_equals(Hue.color_wheel_to_hsv(color_wheel_color_wheel_points[x]), color_wheel_hsv_points[x])
#     print_assert_equals(Hue.hsv_to_color_wheel(color_wheel_hsv_points[x]), color_wheel_color_wheel_points[x])
print("a")
# print_assert_equals(Hue.from_rgb((255, 0, 0)).as_hsv_hue_255(), 0)
# print_assert_equals((Hue(color_wheel_green).color_wheel_progress()), color_wheel_green)
# # print_assert_equals(color_wheel_color_wheel_points[3], color_wheel_green)
# # print_assert_equals(color_wheel_hsv_points[3], hsv_hue_green)
# print_assert_equals(Hue.color_wheel_to_hsv(color_wheel_green), hsv_hue_green)
# print("b")
# print_assert_equals(Hue.hsv_to_color_wheel(hsv_hue_green), color_wheel_green)
# print_assert_equals(Hue(color_wheel_green).as_color_wheel_1(), color_wheel_green)
# print_assert_equals(Hue(color_wheel_green).as_hsv_hue_1(), hsv_hue_green)
# print("c")
# print_assert_equals(Hue(color_wheel_green).as_hsv_hue_360(), 120)
# print_assert_equals(Hue.from_rgb_1(rgb_1_green).as_color_wheel_1(), color_wheel_green)
# print_assert_equals(Hue.list_to_cycle_of(rgb_255_green, 1, original_cycle=255), rgb_1_green)
# print("d")
# print_assert_equals(Hue.from_rgb_255(rgb_255_green).as_color_wheel_1(), color_wheel_green)
# print_assert_equals(Hue.from_rgb_255((0, 255, 0)).as_hsv_hue_360(), 120)
# print_assert_equals(Hue.from_rgb_255((0, 255, 0)).to_generic_255_rgb(), (0, 255, 0))
# print_assert_equals(Hue.from_rgb_255((255, 255, 0)).to_generic_255_rgb(), (255, 255, 0))

# boutta = Hue.from_rgb_255(
#                 (255, 0, 0)
#             ).to_generic_255_rgb()
# print(boutta)
# assert(boutta == (255, 0, 0))

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

def hue_distance(a: Union[float, Hue], b: Union[float, Hue]):
    # originally I tried adding the angles before converting to floats, but like, that makes it loop lol
    if isinstance(a, float):
        a = Hue(a)
    if isinstance(b, float):
        b = Hue(b)

    potentials = [
        a.color_wheel_progress() - (b.color_wheel_progress()    ),
        a.color_wheel_progress() - (b.color_wheel_progress() + 1),
        a.color_wheel_progress() - (b.color_wheel_progress() - 1),
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
        return Hue.from_rgb(bonus_color).horse_palette_alongside()
    elif len(set(bonuses)) == 2:
        # The idea is that uhm
        # Okay imagine a color wheel
        # ....actually I don't wanna explain. check assets\uncombined\jokers\Horse\brainstorm.xcf and figure it out lol
        primary_bonus, _, secondary_bonus = sorted(bonuses, key=lambda x: bonuses.count(x), reverse=True)

        primary_bonus_color = bonus_colors[primary_bonus]
        secondary_bonus_color = bonus_colors[secondary_bonus]

        return Hue.from_rgb(primary_bonus_color).horse_palette_alongside([Hue.from_rgb(secondary_bonus_color)])
    else:
        input = [
            Hue.from_rgb(bonus_colors[bonus])
            for bonus
            in bonuses
        ]
        return input[0].horse_palette_alongside(input[1:])


def clamp_rgb(rgb):
    new_rgb = []
    for band in rgb:
        band = max(band, 0)
        band = min(band, 255)
        new_rgb.append(band)
        # assert band >= 0
        # assert band <= 255
    return tuple(new_rgb)

def color_a_horse(conversions, base_image="horse.png", negative=False):
    for key, rgb in conversions.items():
        rgb = clamp_rgb(rgb)
        if negative:
            rgb = negative_color(rgb)
            rgb = clamp_rgb(rgb)
        conversions[key] = rgb


    horse_image = Image.open(base_image)
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

def apply_horse_accessories(horse_image: Image.Image, accessories: List[str], negative=False):
    for accessory in accessories:
        accessory_image = Image.open(accessory).convert("RGBA")
        horse_image.alpha_composite(accessory_image)

@dataclass
class HorseConfig:
    key: str
    bonuses: List[str]
    jack: bool
    negative: bool


def horse_configs():
    bonus_keys = list(bonus_colors.keys())
    for bonus_1_index, bonus_1 in enumerate(bonus_keys):
        for bonus_2_index, bonus_2 in enumerate(bonus_keys[bonus_1_index:]):
            for bonus_3_index, bonus_3 in enumerate(bonus_keys[bonus_1_index + bonus_2_index:]):
                for jack in [False, True]:
                    for negative in [False, True]:
                        these_bonuses = [
                            bonus_1,
                            bonus_2,
                            bonus_3,
                        ]
                        horse_key = "".join(these_bonuses)
                        if jack:
                            horse_key += "jack"
                        if negative:
                            horse_key += "neg"
                        yield HorseConfig(
                            horse_key,
                            these_bonuses,
                            jack,
                            negative,
                        )


def color_many_horses():
    for horse_config in horse_configs():
        global debug_image
        debug_image = Image.new("HSV", (128, 128), (0, 0, 255))
        colors_for_these_bonuses = get_colors_for_these_bonuses(horse_config.bonuses)
        if not colors_for_these_bonuses:
            continue
        horse = color_a_horse(
            colors_for_these_bonuses,
            base_image="horse_jack.png" if horse_config.jack else "horse.png",
            negative=horse_config.negative
        )

        accessories_maybe = {
            "moneymoneymoney": [
                "accessories/cigar.png",
                "accessories/sunglasses.png",
            ],
            "moneymoneymoneyjack": [
                "accessories/golden_teeth.png",
                "accessories/dollar_sign_eyes.png",
            ]
        }
        accessory_key = horse_config.key.replace("neg", "")
        if accessory_key in accessories_maybe:
            apply_horse_accessories(horse, accessories_maybe[accessory_key], negative=horse_config.negative)

        # Debuggy
        if debug_mode:
            horse_with_debug_image = Image.new("RGBA", (max(debug_image.width, horse.width), debug_image.height + horse.height))
            draw = ImageDraw(horse_with_debug_image)
            horse_with_debug_image.paste(debug_image, (0, 0))
            horse_with_debug_image.paste(horse, (0, debug_image.height))
            draw.text((0, 0), " ".join([re.sub("rsegeswrh", "", s).title() for s in horse_config.bonuses]), "red")
            horse = horse_with_debug_image

        if not os.path.exists(horse_config.key):
            os.mkdir(horse_config.key)
        horse.save(f"{horse_config.key}/{horse_config.key}.png")


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    color_many_horses()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
