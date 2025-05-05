#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

// New
    // So you have to use the namesake of the shader *somewhere*. I don't get why? Seems like a technical restriction, maybe?
    // Like, every vanilla shader does this, so we're stuck with it, or something.
    // This is what it contains:
        // self.ARGS.send_to_shader[1] = math.min(self.VT.r*3, 1) + (math.sin(G.TIMERS.REAL/28) + 1) + (self.juice and self.juice.r*20 or 0) + self.tilt_var.amt
        // self.ARGS.send_to_shader[2] = G.TIMERS.REAL
    extern MY_HIGHP_OR_MEDIUMP vec2 pac_man_screen_summary;

    extern MY_HIGHP_OR_MEDIUMP Image gameplay;
    extern MY_HIGHP_OR_MEDIUMP vec2 gameplay_dims;
    extern MY_HIGHP_OR_MEDIUMP float debug_size_offset;
// New end

extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    MY_HIGHP_OR_MEDIUMP float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	MY_HIGHP_OR_MEDIUMP float t = time * 10.0 + 2003.;
	MY_HIGHP_OR_MEDIUMP vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    MY_HIGHP_OR_MEDIUMP vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	MY_HIGHP_OR_MEDIUMP vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	MY_HIGHP_OR_MEDIUMP vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	MY_HIGHP_OR_MEDIUMP vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    MY_HIGHP_OR_MEDIUMP float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    MY_HIGHP_OR_MEDIUMP vec2 borders = vec2(0.2, 0.8);

    MY_HIGHP_OR_MEDIUMP float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

// New
    vec3 COL_BLACK            = vec3(0.0,        0.0,        0.0)       ;   // #000000
    vec3 COL_CHERRY           = vec3(0.70703125, 0.19140625, 0.125)     ;   // #b43120
    vec3 COL_INKY             = vec3(0.390625,   0.6875,     0.99609375);   // #64affe
    vec3 COL_PINKY            = vec3(0.90625,    0.78125,    0.99609375);   // #e7c7fe
    vec3 COL_CLYDE            = vec3(0.59765625, 0.3046875,  0.0)       ;   // #984e00
    vec3 COL_YELLOW           = vec3(0.9140625,  0.6171875,  0.1328125) ;   // #e99d22
    vec3 COL_WALL             = vec3(0.08203125, 0.37109375, 0.84765625);   // #155fd8
    vec3 COL_BLINKY           = vec3(0.421875,   0.0234375,  0.0)       ;   // #6c0600
    vec3 COL_TITLE_SCREEN_RED = vec3(0.9921875,  0.50390625, 0.4375)    ;   // #fd8070
    vec3 COL_WHITE            = vec3(0.99609375, 0.9921875,  0.99609375);   // #fefdfe

    vec3 COL_BLUNT_RED     = vec3(1.0, 0.0, 0.0);
    vec3 COL_BLUNT_ORANGE  = vec3(1.0, 0.5, 0.0);
    vec3 COL_BLUNT_YELLOW  = vec3(1.0, 1.0, 0.0);
    vec3 COL_BLUNT_GREEN   = vec3(0.0, 1.0, 0.0);
    vec3 COL_BLUNT_CYAN    = vec3(0.0, 1.0, 1.0);
    vec3 COL_BLUNT_BLUE    = vec3(0.0, 0.0, 1.0);
    vec3 COL_BLUNT_PURPLE  = vec3(0.5, 0.0, 1.0);
    vec3 COL_BLUNT_MAGENTA = vec3(1.0, 0.0, 1.0);

    vec3 COL_ERROR = COL_BLUNT_RED;
    vec4 COL_BLANK = vec4(0, 0, 0, 0);
    bool there_was_an_error = false;
    vec4 COL_THAT_GETS_SET_WHEN_THERES_AN_ERROR = COL_BLANK;
    vec4 COL_DEBUG_GRID = COL_BLANK;

    // vec3 COL_WALL  = vec3(21.0/255.0, 95.0/255.0, 216.0/255.0);
    // vec3 COL_BLACK = vec3(0.0, 0.0,     0.0    );

    // I'm certain there's a less silly way to do this, but alas
    vec2 round(vec2 inputty) {return floor(inputty + 0.5);}
    vec3 round(vec3 inputty) {return floor(inputty + 0.5);}

    /*
        Okay hm
        Normalized ranges from 0 <= n <= 1, but we don't actually want 1 to corespond to a unique pixel value, so we should clamp it
        and I guess, corespondingly, the highest possible pixel value wouldn't give you 1. Like, 1 would be a valid answer, but only because of the clamping.
        My original thought was that we would want to give the first(lowest) valid answer, but actually, I think we'd be better off with something in the middle, maybe. Keeps us away from the borders, where floating point imprecision might catch us.
    */
    vec2 card_dims = vec2(71, 95);
    vec2 half_off = vec2(0.5, 0.5);
    vec2 normalized_to_card_pixel(vec2 coords) {return min(floor(coords * card_dims    ), card_dims     - 1);}
    vec2 normalized_to_game_pixel(vec2 coords) {return min(floor(coords * gameplay_dims), gameplay_dims - 1);}
    vec2 card_pixel_to_normalized(vec2 coords) {return       (coords + half_off) / card_dims     ;}
    vec2 game_pixel_to_normalized(vec2 coords) {return       (coords + half_off) / gameplay_dims ;}

    // These seem like they should make sense mathematically but it slowly misaligns so I guess not?
    // vec2 card_pixel_to_normalized(vec2 coords) {return       vec2((floor(coords.x) + 0.5) /  71.0, (floor(coords.y) + 0.5) /  95.0 ) ;}
    // vec2 game_pixel_to_normalized(vec2 coords) {return       vec2((floor(coords.x) + 0.5) / 256.0, (floor(coords.y) + 0.5) / 240.0 ) ;}

    bool compare_normalized_colors(vec3 a_normalized, vec3 b_normalized) {
        float lenience = 2.0 / 256.0;
        vec3 dif = abs(a_normalized-b_normalized);
        // return floor(a_normalized * 255.0 + 0.25) == floor(b_normalized * 255.0 + 0.25);
        return (dif.r + dif.g + dif.b) <= lenience;
        // return all(
        //     lessThanEqual(
        //         abs(
        //             (a_normalized-b_normalized) * 255.0
        //         ),
        //         vec3(lenience, lenience, lenience)
        //     )
        // );
    }

    vec3 normalized_color_at(vec2 this_pixel) {
        return Texel(gameplay, game_pixel_to_normalized(this_pixel)).rgb;
        // return max(vec3(1,1,1), Texel(gameplay, game_pixel_to_normalized(this_pixel)).rgb);
    }

    bool is_normalized_color_at(vec2 this_pixel, vec3 normalized_color) {
        return compare_normalized_colors(
            normalized_color_at(this_pixel),
            normalized_color
        );
    }

    

    vec3 convert_palette(vec3 rgb) {
        if (compare_normalized_colors(rgb, COL_WALL  )) {return COL_WALL * 7. / 8;}

        if (compare_normalized_colors(rgb, COL_BLINKY)) {return vec3(0.94f, 0.3f, 0.3f);}  // #f04d4d #de0f0f
        // if (compare_normalized_colors(rgb, COL_INKY  )) {return vec3(0.12f, 0.59f, 1.f);}  // #1e96fe
        // if (compare_normalized_colors(rgb, COL_PINKY )) {return vec3(0.7f, 0.2f, 0.76f);}  // #b332c2
        if (compare_normalized_colors(rgb, COL_CLYDE )) {return vec3(0.98f, 0.56f, 0.f);}  // #fa8f00
        return rgb;
    }

    vec3 processed_pixel_for(vec2 card_texture_coords_normalized) {
        vec2 card_pixel_pos = normalized_to_card_pixel(card_texture_coords_normalized) * 8;  // Each pixel on the card represents 8x8 on the game screen

        // GUI, seems there's only ever one color per block on the right side, so just return the first thing seen (that'll look nice)
        // This could *absolutley* be optimized but it probably doesn't matter
        if (card_pixel_pos.x >= 176) {
            for (int x_offset = 0; x_offset < 8; x_offset++) {
                for (int y_offset = 0; y_offset < 8; y_offset++) {
                    vec2 offset = vec2(x_offset, y_offset);
                    if (!is_normalized_color_at(card_pixel_pos + offset, COL_BLACK)) {
                        return normalized_color_at(card_pixel_pos + offset);
                    }
                }
            }
            return COL_BLACK;
        }

        // Walls
        if (is_normalized_color_at(card_pixel_pos + vec2(2.0, 2.0), COL_WALL)) {return COL_WALL;};
        if (is_normalized_color_at(card_pixel_pos + vec2(5.0, 5.0), COL_WALL)) {return COL_WALL;};
        if (is_normalized_color_at(card_pixel_pos + vec2(2.0, 5.0), COL_WALL)) {return COL_WALL;};
        if (is_normalized_color_at(card_pixel_pos + vec2(5.0, 2.0), COL_WALL)) {return COL_WALL;};

        // Dots, doing it exactly like this stops it from picking up parts of the life counter
        if (
            is_normalized_color_at(card_pixel_pos + vec2(3.0, 2.0), COL_BLACK) && 
            is_normalized_color_at(card_pixel_pos + vec2(3.0, 3.0), COL_YELLOW)
        ) {return COL_YELLOW / 3;};

        // Dudes, checks if three of the four corners contain dudes :)
        vec3 dude_colors[6] = vec3[](COL_BLINKY, COL_INKY, COL_PINKY, COL_CLYDE, COL_YELLOW, COL_WHITE);
        vec2 corners[4] = vec2[](vec2(1.0, 1.0), vec2(6.0, 6.0), vec2(1.0, 6.0), vec2(6.0, 1.0));
        vec3 output_dude_color = vec3(0, 0, 0);
        int dudes_spotted = 0;
        for (int corner_index=0; corner_index < corners.length(); corner_index++) {
            vec2 corner = corners[corner_index];
            vec3 corner_color = normalized_color_at(card_pixel_pos + corner);
            for (int dude_index=0; dude_index < dude_colors.length(); dude_index++) {
                vec3 dude_color = dude_colors[dude_index];
                if (!compare_normalized_colors(corner_color, dude_color)) {continue;}

                // If it hits a ghost's eye, go down until you get the body
                vec2 white_avoiding_offset = vec2(0, 0);
                while (compare_normalized_colors(corner_color, COL_WHITE)) {
                    white_avoiding_offset += vec2(0, 1);
                    corner_color = normalized_color_at(card_pixel_pos + corner + white_avoiding_offset);
                }

                output_dude_color += convert_palette(corner_color);
                dudes_spotted++;
                break;
            }
        }
        if (dudes_spotted > corners.length()) {
            return COL_BLUNT_MAGENTA;
        }
        if (dudes_spotted >= 3) {
            return  output_dude_color / dudes_spotted; // COL_BLUNT_CYAN; //
        }

        return COL_BLACK; // Texel(gameplay, game_pixel_to_normalized(card_pixel_pos+vec2(4., 5.))).rgb;
    }

    void debug_grid(number check_count, vec2 texture_coords, bool test) {
        number count = 16;
        number grid_index = floor(texture_coords.x*count) + floor(texture_coords.y*count) * count;
        if (COL_DEBUG_GRID != COL_BLANK) {
            return;
        }
        else if (check_count != grid_index) {
            return;
        } else if (!test && mod(floor(pac_man_screen_summary[1] * 2), 2) == 0) {
            COL_THAT_GETS_SET_WHEN_THERES_AN_ERROR = vec4(COL_ERROR, 1);
            there_was_an_error = true;
            COL_DEBUG_GRID = COL_THAT_GETS_SET_WHEN_THERES_AN_ERROR;
        } else if (mod(grid_index + floor(texture_coords.y*count), 2) == 0) {
            COL_DEBUG_GRID = (vec4(COL_ERROR, 1) + vec4(0.25, 0.25, 0.25, 1) * 1) / 2;
        } else {
            COL_DEBUG_GRID = (vec4(COL_ERROR, 1) + vec4(0.35, 0.35, 0.35, 1) * 1) / 2;
        }
    }

    //Source: https://github.com/tobspr/GLSL-Color-Spaces/blob/master/ColorSpaces.inc.glsl
    #ifndef saturate
    #define saturate(v) clamp(v,0.,1.)
    //      clamp(v,0.,1.)
    #endif

    //HSV (hue, saturation, value) to RGB.
    //Sources: https://gist.github.com/yiwenl/745bfea7f04c456e0101, https://gist.github.com/sugi-cho/6a01cae436acddd72bdf
    vec3 hsv2rgb(vec3 c){
        vec4 K=vec4(1.,2./3.,1./3.,3.);
        return c.z*mix(K.xxx,saturate(abs(fract(c.x+K.xyz)*6.-K.w)-K.x),c.y);
    }
// New end

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // New
        if (true) {
            highp float check_count = 0.0;
            vec4 COL_BLANK;
            // r, g, b of output
            // r, g, b of failure color
            //  
            // vec(0, 0,)
            
            COL_ERROR = COL_BLUNT_RED;
            debug_grid(check_count++, texture_coords, compare_normalized_colors(COL_WALL, COL_WALL)); 
            debug_grid(check_count++, texture_coords, (1. / 2. == 0.5))              ; 
            debug_grid(check_count++, texture_coords, (float(1) / float(2) == 0.5)); 
            debug_grid(check_count++, texture_coords, (float(1) / 2 == 0.5))       ; 
            
            COL_ERROR = COL_BLUNT_ORANGE;
            debug_grid(check_count++, texture_coords, (1        / float(2) == 0.5)); 
            debug_grid(check_count++, texture_coords, (1 + 0.5 == 1.5))            ; 
            debug_grid(check_count++, texture_coords, compare_normalized_colors(vec3(0.0, 0.0, 0.0), vec3(0.0, 0.0, 0.0)));
            debug_grid(check_count++, texture_coords, compare_normalized_colors(vec3(0.0, 0.0, 0.0), vec3(0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0)));
            
            COL_ERROR = COL_BLUNT_YELLOW;
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).r <= 1.5);
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).g <= 1.5);
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).b <= 1.5);

            COL_ERROR = COL_BLUNT_GREEN;
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).r <= 1.0);
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).g <= 1.0);
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).b <= 1.0);

            COL_ERROR = COL_BLUNT_CYAN;
            debug_grid(check_count++, texture_coords, (normalized_color_at(vec2(1, 1)).r <= 10./255.));
            debug_grid(check_count++, texture_coords, (normalized_color_at(vec2(1, 1)).g <= 10./255.)); 
            debug_grid(check_count++, texture_coords, (normalized_color_at(vec2(1, 1)).b <= 10./255.));

            COL_ERROR = COL_BLUNT_BLUE;
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).r <= 0.0);
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).g <= 0.0);
            debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).b <= 0.0);

            COL_ERROR = COL_BLUNT_PURPLE;
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53.0, 18.0-1.0)), COL_BLACK));
            // check_count++;
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53.0, 18.0-2.0)), COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53.0, 18.0-1.0)), COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53.0, 18.0-0.0)), COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53.0, 18.0+1.0)), COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53.0, 18.0+2.0)), COL_WALL));
            
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53.0, 18.0)), COL_WALL));
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53.0, 226.0)), COL_WALL));

            COL_ERROR = COL_BLUNT_MAGENTA;
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(27, 18)), COL_WALL)); 
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(1, 1)), COL_BLACK));
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(vec3(1.0/255.0, 1.0/255.0, 1.0/255.0), vec3(5.0/255.0, 5.0/255.0, 5.0/255.0)));

            COL_ERROR = COL_BLUNT_ORANGE;
            debug_grid(check_count++, texture_coords, normalized_to_card_pixel(vec2(0,0)) == vec2(0,0));
            debug_grid(check_count++, texture_coords, normalized_to_game_pixel(vec2(0,0)) == vec2(0,0));
            debug_grid(check_count++, texture_coords, normalized_to_card_pixel(vec2(1,1)) == vec2(70,94));
            debug_grid(check_count++, texture_coords, normalized_to_game_pixel(vec2(1,1)) == vec2(255,239));

            COL_ERROR = COL_BLUNT_YELLOW;
            debug_grid(check_count++, texture_coords, all(lessThan(   vec2( 0./ 71., 0./ 95.), card_pixel_to_normalized(vec2(0,0)))));
            debug_grid(check_count++, texture_coords, all(lessThan(   vec2( 0./256., 0./240.), game_pixel_to_normalized(vec2(0,0)))));
            debug_grid(check_count++, texture_coords, all(greaterThan(vec2( 1./ 71., 1./ 95.), card_pixel_to_normalized(vec2(0,0)))));
            debug_grid(check_count++, texture_coords, all(greaterThan(vec2( 1./256., 1./240.), game_pixel_to_normalized(vec2(0,0)))));

            COL_ERROR = COL_BLUNT_GREEN;
            debug_grid(check_count++, texture_coords, all(lessThan(   vec2(  70./ 71.,  94./ 95.), card_pixel_to_normalized(vec2(70,   94)))));
            debug_grid(check_count++, texture_coords, all(lessThan(   vec2( 255./256., 239./240.), game_pixel_to_normalized(vec2(255, 239)))));
            debug_grid(check_count++, texture_coords, all(greaterThan(vec2(  71./ 71.,  95./ 95.), card_pixel_to_normalized(vec2(70,   94)))));
            debug_grid(check_count++, texture_coords, all(greaterThan(vec2( 256./256., 240./240.), game_pixel_to_normalized(vec2(255, 239)))));

            COL_ERROR = COL_BLUNT_CYAN;
            // Trying to figure out exactly what this thing wants from me 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 8.5  / 257, 42.5  / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 8.5  / 256, 42.5  / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 8.5  / 255, 42.5  / 239.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.   / 257, 43.   / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.   / 256, 43.   / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.   / 255, 43.   / 239.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.25 / 257, 43.25 / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.25 / 256, 43.25 / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.25 / 255, 43.25 / 239.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.5  / 257, 43.5  / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.5  / 256, 43.5  / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.5  / 255, 43.5  / 239.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.75 / 257, 43.75 / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.75 / 256, 43.75 / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 9.75 / 255, 43.75 / 239.) ).rgb, COL_WALL)); 
            debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 10.5  / 257, 44.5   / 241.) ).rgb, COL_WALL)); 
            debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 10.5  / 256, 44.5   / 240.) ).rgb, COL_WALL)); 
            debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2( 10.5  / 255, 44.5   / 239.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.25 / 257, 44.25 / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.25 / 256, 44.25 / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.25 / 255, 44.25 / 239.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.5  / 257, 44.5  / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.5  / 256, 44.5  / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.5  / 255, 44.5  / 239.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.75 / 257, 44.75 / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.75 / 256, 44.75 / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(10.75 / 255, 44.75 / 239.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(11.   / 257, 45.   / 241.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(11.   / 256, 45.   / 240.) ).rgb, COL_WALL)); 
            // debug_grid(check_count++, texture_coords, compare_normalized_colors(Texel(gameplay, vec2(11.   / 255, 45.   / 239.) ).rgb, COL_WALL));

            COL_ERROR = COL_BLUNT_BLUE;
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(80, 96) + vec2(1, 1)), COL_CLYDE)); 
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(80, 96) + vec2(6, 1)), COL_WHITE)); 
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(80, 96) + vec2(6, 6)), COL_CLYDE)); 
            debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(80, 96) + vec2(1, 6)), COL_CLYDE)); 

            if (COL_DEBUG_GRID != COL_BLANK) {return COL_DEBUG_GRID;};
        }
            
        MY_HIGHP_OR_MEDIUMP vec4 tex = Texel( texture, texture_coords);
        MY_HIGHP_OR_MEDIUMP vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
        vec2 draw_offset = card_pixel_to_normalized(vec2(4, 32)) + vec2(0, 2./8.);

        // Vertical
        // if (texture_coords.x < 1./5.) {
        //     tex.rgb = normalized_color_at(vec2(53.0, 18-0.5+texture_coords.y));
        // } else if (texture_coords.x < 2./5.) {
        //     tex.rgb = normalized_color_at(vec2(53.0, 21-0.5+texture_coords.y));
        // }  else if (texture_coords.x < 3./5.) {
        //     tex.rgb = COL_WALL;
        // }  else if (texture_coords.x < 4./5.) {
        //     tex.rgb = normalized_color_at(vec2(53.0, 226-0.5+texture_coords.y));
        // } else {
        //     tex.rgb = normalized_color_at(vec2(53.0, 229-0.5+texture_coords.y));
        // }

        // Horizontal
        // THIS WORKS!!!
        // float bso = 0;
        // float pixel_offset = 0.5;
        // if        (texture_coords.x < 1./5.) {tex.rgb = texture2D(gameplay, vec2(pixel_offset + 10.0  - 2 + texture_coords.y * 4, pixel_offset + 44) / gameplay_dims).rgb;
        // } else if (texture_coords.x < 2./5.) {tex.rgb = texture2D(gameplay, vec2(pixel_offset + 13.0  - 2 + texture_coords.y * 4, pixel_offset + 44) / gameplay_dims).rgb;} else if (texture_coords.x < 2.5/5.) {tex.rgb = texture2D(gameplay, vec2(10.0 + pixel_offset, 44 + pixel_offset) / gameplay_dims).rgb;} else if (texture_coords.x < 3./5.) {tex.rgb = COL_WALL;
        // } else if (texture_coords.x < 4./5.) {tex.rgb = texture2D(gameplay, vec2(pixel_offset + 170.0 - 2 + texture_coords.y * 4, pixel_offset + 44) / gameplay_dims).rgb;
        // } else                               {tex.rgb = texture2D(gameplay, vec2(pixel_offset + 173.0 - 2 + texture_coords.y * 4, pixel_offset + 44) / gameplay_dims).rgb;
        // }
        float bso = 0;
        float pixel_offset = 0.5;
        vec2 focuses[4] = vec2[](
            vec2(80, 96) + vec2(1, 1),
            vec2(80, 96) + vec2(6, 1),
            vec2(80, 96) + vec2(6, 6),
            vec2(80, 96) + vec2(1, 6)
        );
        if        (texture_coords.x < 1./5.) {tex.rgb = texture2D(gameplay, vec2(pixel_offset + focuses[0].x - 2 + texture_coords.y * 4, pixel_offset + focuses[0].y) / gameplay_dims).rgb;
        } else if (texture_coords.x < 2./5.) {tex.rgb = texture2D(gameplay, vec2(pixel_offset + focuses[1].x - 2 + texture_coords.y * 4, pixel_offset + focuses[1].y) / gameplay_dims).rgb;} else if (texture_coords.x < 2.5/5.) {tex.rgb = texture2D(gameplay, vec2(10.0 + pixel_offset, 44 + pixel_offset) / gameplay_dims).rgb;} else if (texture_coords.x < 3./5.) {tex.rgb = COL_BLINKY;
        } else if (texture_coords.x < 4./5.) {tex.rgb = texture2D(gameplay, vec2(pixel_offset + focuses[2].x - 2 + texture_coords.y * 4, pixel_offset + focuses[2].y) / gameplay_dims).rgb;
        } else                               {tex.rgb = texture2D(gameplay, vec2(pixel_offset + focuses[3].x - 2 + texture_coords.y * 4, pixel_offset + focuses[3].y) / gameplay_dims).rgb;
        };
        
        if      (texture_coords.x < 1.  / 10.) {tex.rgb = COL_BLACK           ;}
        else if (texture_coords.x < 2.  / 10.) {tex.rgb = COL_CHERRY          ;}
        else if (texture_coords.x < 3.  / 10.) {tex.rgb = COL_INKY            ;}
        else if (texture_coords.x < 4.  / 10.) {tex.rgb = COL_PINKY           ;}
        else if (texture_coords.x < 5.  / 10.) {tex.rgb = COL_CLYDE           ;}
        else if (texture_coords.x < 6.  / 10.) {tex.rgb = COL_YELLOW          ;}
        else if (texture_coords.x < 7.  / 10.) {tex.rgb = COL_WALL            ;}
        else if (texture_coords.x < 8.  / 10.) {tex.rgb = COL_BLINKY          ;}
        else if (texture_coords.x < 9.  / 10.) {tex.rgb = COL_TITLE_SCREEN_RED;}
        else if (texture_coords.x < 10. / 10.) {tex.rgb = COL_WHITE           ;}

        if (
            normalized_to_card_pixel(texture_coords - draw_offset).x < 256/8 &&
            normalized_to_card_pixel(texture_coords - draw_offset).y < 240/8 &&
            normalized_to_card_pixel(texture_coords - draw_offset).x > 0     &&
            normalized_to_card_pixel(texture_coords - draw_offset).y > 0    
        ) {
            // for(int x_plus=0; x_plus<8; x_plus++) {
            //     for(int y_plus=0; y_plus<8; y_plus++) {
            //         if 
            //     }
            // }
            tex.rgb = processed_pixel_for(texture_coords-draw_offset);
            tex.rgb = convert_palette(tex.rgb);
            if (tex.rgb == vec3(0, 0, 0)) {
                tex.a = 7 / 8.;
            }
            
            // This is just because it *has* to do *something* with pac_man_screen_summary.
            // Theoretically it'll never actually affect anything.
            tex.a = tex.a + min(0, pac_man_screen_summary.y);
        }
    // New end

    if (!shadow &&  dissolve > 0.01){
        if (burn_colour_2.a > 0.01){
            tex.rgb = tex.rgb*(1.-0.6*dissolve) + 0.6*burn_colour_2.rgb*dissolve;
        } else if (burn_colour_1.a > 0.01){
            tex.rgb = tex.rgb*(1.-0.6*dissolve) + 0.6*burn_colour_1.rgb*dissolve;
        }
    }

    return dissolve_mask(tex, texture_coords, uv);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    MY_HIGHP_OR_MEDIUMP float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    MY_HIGHP_OR_MEDIUMP vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    MY_HIGHP_OR_MEDIUMP float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif