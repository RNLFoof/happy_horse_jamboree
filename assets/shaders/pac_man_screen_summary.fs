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
    vec3 COL_WALL  = vec3(0.082, 0.373, 0.851);
    vec3 COL_BLACK = vec3(0.0, 0.0,     0.0    );

    // I'm certain there's a less silly way to do this, but alas
    vec2 round(vec2 inputty) {return floor(inputty + 0.5);}
    vec3 round(vec3 inputty) {return floor(inputty + 0.5);}

    vec2 normalized_to_card_pixel(vec2 coords) {return round(vec2(coords.x *  71.0,  coords.y * 95.0));}
    vec2 normalized_to_game_pixel(vec2 coords) {return round(vec2(coords.x * 256.0, coords.y * 240.0));}
    vec2 card_pixel_to_normalized(vec2 coords) {return       vec2(coords.x /  71.0,  coords.y / 95.0 ) ;}
    vec2 game_pixel_to_normalized(vec2 coords) {return       vec2(coords.x / 256.0, coords.y / 240.0 ) ;}

    bool compare_normalized_colors(vec3 a_normalized, vec3 b_normalized) {
        return floor(a_normalized * 255.0 + 0.5) == floor(b_normalized * 255.0 + 0.5);
    }

    vec3 normalized_color_at(vec2 this_pixel) {
        return vec3(1,1,1), Texel(gameplay, game_pixel_to_normalized(this_pixel)).rgb;
        // return max(vec3(1,1,1), Texel(gameplay, game_pixel_to_normalized(this_pixel)).rgb);
    }

    bool is_normalized_color_at(vec2 this_pixel, vec3 normalized_color) {
        return compare_normalized_colors(
            normalized_color_at(this_pixel),
            normalized_color
        );
    }

    vec3 processed_pixel_for(vec2 card_texture_coords_normalized) {
        vec2 card_pixel_pos = normalized_to_card_pixel(card_texture_coords_normalized) * 8;  // Each pixel on the card represents 8x8 on the game screen

        if (is_normalized_color_at(card_pixel_pos + vec2(2.0, 2.0), COL_WALL)) {return COL_WALL;};
        if (is_normalized_color_at(card_pixel_pos + vec2(5.0, 5.0), COL_WALL)) {return COL_WALL;};
        if (is_normalized_color_at(card_pixel_pos + vec2(2.0, 5.0), COL_WALL)) {return COL_WALL;};
        if (is_normalized_color_at(card_pixel_pos + vec2(5.0, 2.0), COL_WALL)) {return COL_WALL;};

        return Texel(gameplay, game_pixel_to_normalized(card_pixel_pos+vec2(4, 4))).rgb;  // If nothing is found, just use whatever's in the middle of the block
    }
// New end
vec4 debug_grid(number check_count, vec2 texture_coords, bool test) {
    number grid_index = floor(texture_coords.x*8) + floor(texture_coords.y*8) * 8;
    if (check_count != grid_index) {
        return vec4(0, 0, 0, 0);
    } else if (!test) {
        return vec4(1, 0, 1, 1);
    } else if (mod(grid_index + floor(texture_coords.y*8), 2) == 0) {
        return vec4(0.25, 0.25, 0.25, 1);
    } else {
        return vec4(0.75, 0.75, 0.75, 1);
    }
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // New
        highp float check_count = 0.0;
        vec4 outputty = vec4(0,0,0,0);
        
        /*                                                 */ outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(COL_WALL, COL_WALL)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, (1. / 2. == 0.5))              ; 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, (float(1) / float(2) == 0.5)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, (float(1) / 2 == 0.5))       ; 
        
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, (1        / float(2) == 0.5)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, (1 + 0.5 == 1.5))            ; 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(vec3(0.0, 0.0, 0.0), vec3(0.0, 0.0, 0.0)));
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(vec3(0.0, 0.0, 0.0), vec3(0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0)));
        
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).r <= 1.5);
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).g <= 1.5);
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).b <= 1.5);
        check_count++;

        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).r <= 1.0);
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).g <= 1.0);
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).b <= 1.0);
        check_count++;

        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, (normalized_color_at(vec2(1, 1)).r <= 10./255.));
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, (normalized_color_at(vec2(1, 1)).g <= 10./255.)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, (normalized_color_at(vec2(1, 1)).b <= 10./255.));
        check_count++;

        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).r <= 0.0);
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).g <= 0.0);
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, normalized_color_at(vec2(1, 1)).b <= 0.0);
        check_count++;

        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, !compare_normalized_colors(normalized_color_at(vec2(53, 18-2)), COL_BLACK)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, !compare_normalized_colors(normalized_color_at(vec2(53, 18-1)), COL_BLACK)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, !compare_normalized_colors(normalized_color_at(vec2(53, 18-0)), COL_BLACK)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, !compare_normalized_colors(normalized_color_at(vec2(53, 18+1)), COL_BLACK)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, !compare_normalized_colors(normalized_color_at(vec2(53, 18+2)), COL_BLACK));
        check_count++;
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53, 18-2)), COL_WALL)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53, 18-1)), COL_WALL)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53, 18-0)), COL_WALL)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53, 18+1)), COL_WALL)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(53, 18+2)), COL_WALL));
        check_count++;

        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(27, 9)), COL_WALL)); 
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;}; outputty = debug_grid(check_count++, texture_coords, compare_normalized_colors(normalized_color_at(vec2(1, 1)), COL_BLACK));
        if (outputty != vec4(0, 0, 0, 0)) {return outputty;};
            
        MY_HIGHP_OR_MEDIUMP vec4 tex = Texel( texture, texture_coords);
        MY_HIGHP_OR_MEDIUMP vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
        vec2 draw_offset = card_pixel_to_normalized(vec2(4, 32));

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