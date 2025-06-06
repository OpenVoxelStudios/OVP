#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

uniform vec2 ScreenSize;
in vec2 texCoord0;
in vec4 vertexColor;
flat in float LogoTest;
out vec4 fragColor;

//#define DEBUG
//#define SCREENDEBUG

#moj_import <minecraft:draw_logo.glsl>
#moj_import <minecraft:important_config.glsl>

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor;
    if (color.a == 0.0 && LogoTest != 1.0) {
        discard;
    }
    fragColor = color * ColorModulator;
    vec2 uv = texCoord0.xy;
    uv.y = uv.y - 0.5;
    uv.y = uv.y * 2;
    uv.y = uv.y * -1;
    SCREENSIZE = gl_FragCoord.xy / uv;
    //SCREENSIZE.x = SCREENSIZE.x / 2;
    #ifdef Screensize
        SCREENSIZE = ScreenSize;
        uv = gl_FragCoord.xy / SCREENSIZE;
    #endif
    //vec2 uv = gl_FragCoord.xy / SCREENSIZE;
   if (LogoTest == 1.0) {
        fragColor = vec4(0.0,0.0,0.0,vertexColor.a);
    
    #ifdef DEBUG
        fragColor = vec4(uv.x,uv.y,0.0,vertexColor.a);
    #endif
    #ifdef SCREENDEBUG
        fragColor = vec4(encodeIntToRGB(SCREENSIZE.y),1.0);
    #endif
    #ifndef DEBUG
        if (drawMain(uv,SCREENSIZE,vertexColor.a)) {
            float gradient = (uv.x+uv.y)/2;
            gradient = pow(gradient,1.5);
            vec3 orang = vec3(227, 113, 0);
            orang = orang / 255;
            fragColor = vec4(vec3(gradient)*orang,vertexColor.a);
        }
    #endif
    }
}

