// sRGB -> Linear conversion (needed because Ghostty passes sRGB values but the shader pipeline operates in linear color space)
vec3 sRGBToLinear(vec3 c) {
    return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(vec3(0.04045), c));
}

// --- CONFIGURATION ---
vec4 getTrailColor() {
    return vec4(sRGBToLinear(iCurrentCursorColor.rgb), iCurrentCursorColor.a); // for custom color: vec4(0.2, 0.6, 1.0, 0.5); (wrap in sRGBToLinear for correct brightness)
}
const float DURATION = 0.12; // in seconds
const bool ANIMATE_WHEN_UNFOCUSED = false; // Ghostty 1.3+: allow effects while the surface is unfocused
const float MAX_TRAIL_LENGTH = 0.2;
const float THRESHOLD_MIN_DISTANCE = 1.5; // min distance to show trail (units of cursor width)
const float BLUR = 2.0; // blur size in pixels (for antialiasing)

// --- CONSTANTS for easing functions ---
const float PI = 3.14159265359;
const float C1_BACK = 1.70158;
const float C2_BACK = C1_BACK * 1.525;
const float C3_BACK = C1_BACK + 1.0;
const float C4_ELASTIC = (2.0 * PI) / 3.0;
const float C5_ELASTIC = (2.0 * PI) / 4.5;
const float SPRING_STIFFNESS = 9.0;
const float SPRING_DAMPING = 0.9;

// --- EASING FUNCTIONS ---

// // Linear
// float ease(float x) {
//     return x;
// }

// // EaseOutQuad
// float ease(float x) {
//     return 1.0 - (1.0 - x) * (1.0 - x);
// }

// // EaseOutCubic
// float ease(float x) {
//     return 1.0 - pow(1.0 - x, 3.0);
// }


// // EaseOutQuart
// float ease(float x) {
//     return 1.0 - pow(1.0 - x, 4.0);
// }

// // EaseOutQuint
// float ease(float x) {
//     return 1.0 - pow(1.0 - x, 5.0);
// }

// // EaseOutSine
// float ease(float x) {
//     return sin((x * PI) / 2.0);
// }

// // EaseOutExpo
// float ease(float x) {
//     return x == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * x);
// }

// Smooth polynomial ease-out: finite initial speed and zero velocity at the end.
float ease(float x) {
    return x * (1.5 - 0.5 * x * x);
}

// // EaseOutCirc
// float ease(float x) {
//     float remaining = 1.0 - x;
//     return sqrt(1.0 - remaining * remaining);
// }

// // EaseOutBack
// float ease(float x) {
//     return 1.0 + C3_BACK * pow(x - 1.0, 3.0) + C1_BACK * pow(x - 1.0, 2.0);
// }

// // EaseOutElastic
// float ease(float x) {
//     return x == 0.0 ? 0.0
//          : x == 1.0 ? 1.0
//                     : pow(2.0, -10.0 * x) * sin((x * 10.0 - 0.75) * C4_ELASTIC) + 1.0;
// }

// Parametric Spring
// float ease(float x) {
//     x = clamp(x, 0.0, 1.0);
//     float decay = exp(-SPRING_DAMPING * SPRING_STIFFNESS * x);
//     float freq = sqrt(SPRING_STIFFNESS * (1.0 - SPRING_DAMPING * SPRING_DAMPING));
//     float osc = cos(freq * 6.283185 * x) + (SPRING_DAMPING * sqrt(SPRING_STIFFNESS) / freq) * sin(freq * 6.283185 * x);
//     return 1.0 - decay * osc;
// }

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    float edgeLengthSquared = dot(e, e);
    if (edgeLengthSquared <= 1e-12) {
        return d;
    }
    vec2 proj = a + e * clamp(dot(w, e) / edgeLengthSquared, 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

float antialising(float distance, float blurWidth) {
    if (blurWidth <= 0.0) {
        return step(distance, 0.0);
    }
    return 1.0 - smoothstep(0.0, blurWidth, distance);
}

float determineIfTopRightIsLeading(vec2 a, vec2 b) {
    float condition1 = step(b.x, a.x) * step(a.y, b.y); // a.x < b.x && a.y > b.y
    float condition2 = step(a.x, b.x) * step(b.y, a.y); // a.x > b.x && a.y < b.y

    // if neither condition is met, return 1 (else case)
    return 1.0 - max(condition1, condition2);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    // Ghostty 1.3 exposes focus state; older prefixes omit both this macro and iFocus.
    #if defined(CURSORSTYLE_BLOCK)
    if (!ANIMATE_WHEN_UNFOCUSED && iFocus == 0) {
        return;
    }
    #endif

    float baseProgress = iTime - iTimeCursorChange;
    vec2 currentCenterPixels = iCurrentCursor.xy + iCurrentCursor.zw * vec2(0.5, -0.5);
    vec2 previousCenterPixels = iPreviousCursor.xy + iPreviousCursor.zw * vec2(0.5, -0.5);
    vec2 movementPixels = currentCenterPixels - previousCenterPixels;
    float minDistancePixels = iCurrentCursor.w * THRESHOLD_MIN_DISTANCE;

    // This branch is uniform across the frame and keeps idle work to the texture sample.
    if (dot(movementPixels, movementPixels) <= minDistancePixels * minDistancePixels
            || baseProgress >= DURATION) {
        return;
    }

    float coordinateScale = 2.0 / iResolution.y;
    vec2 viewportOffset = iResolution.xy * (coordinateScale * 0.5);
    vec2 vu = fragCoord * coordinateScale - viewportOffset;
    vec4 currentCursor = vec4(
        iCurrentCursor.xy * coordinateScale - viewportOffset,
        iCurrentCursor.zw * coordinateScale
    );
    vec4 previousCursor = vec4(
        iPreviousCursor.xy * coordinateScale - viewportOffset,
        iPreviousCursor.zw * coordinateScale
    );
    vec2 centerCC = currentCursor.xy + currentCursor.zw * vec2(0.5, -0.5);
    vec2 centerCP = previousCursor.xy + previousCursor.zw * vec2(0.5, -0.5);
    vec2 delta = centerCP - centerCC;
    float lineLength = length(delta);
    float progress = clamp(baseProgress / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);
    // Anchor the head at the destination and retract a length-capped tail continuously.
    float tailStart = clamp(
        1.0 - MAX_TRAIL_LENGTH / max(lineLength, 1e-6),
        0.0,
        1.0
    );
    float headEased = 1.0;
    float tailEased = mix(tailStart, 1.0, easedProgress);

    float blurWidth = max(BLUR, 0.0) * coordinateScale;
    vec2 absoluteDelta = abs(delta);
    const float STRAIGHT_MOVE_THRESHOLD = 0.001;
    bool isStraightMove = absoluteDelta.x <= STRAIGHT_MOVE_THRESHOLD
                       || absoluteDelta.y <= STRAIGHT_MOVE_THRESHOLD;
    float sdfTrail;

    if (isStraightMove) {
        vec2 headCenter = mix(centerCP, centerCC, headEased);
        vec2 tailCenter = mix(centerCP, centerCC, tailEased);
        vec2 minCenter = min(headCenter, tailCenter);
        vec2 maxCenter = max(headCenter, tailCenter);
        vec2 boxSize = (maxCenter - minCenter) + currentCursor.zw;
        vec2 boxCenter = (minCenter + maxCenter) * 0.5;
        vec2 halfSize = boxSize * 0.5;
        vec2 boundsPadding = vec2(blurWidth);

        if (any(lessThan(vu, boxCenter - halfSize - boundsPadding))
                || any(greaterThan(vu, boxCenter + halfSize + boundsPadding))) {
            return;
        }

        sdfTrail = getSdfRectangle(vu, boxCenter, halfSize);
    } else {
        vec2 headPosition = mix(previousCursor.xy, currentCursor.xy, headEased);
        vec2 tailPosition = mix(previousCursor.xy, currentCursor.xy, tailEased);
        float isTopRightLeading = determineIfTopRightIsLeading(currentCursor.xy, previousCursor.xy);
        float isBottomLeftLeading = 1.0 - isTopRightLeading;
        vec2 v0 = vec2(headPosition.x + currentCursor.z * isTopRightLeading, headPosition.y - currentCursor.w);
        vec2 v1 = vec2(headPosition.x + currentCursor.z * isBottomLeftLeading, headPosition.y);
        vec2 v2 = vec2(tailPosition.x + currentCursor.z * isBottomLeftLeading, tailPosition.y);
        vec2 v3 = vec2(tailPosition.x + currentCursor.z * isTopRightLeading, tailPosition.y - previousCursor.w);
        vec2 boundsMin = min(min(v0, v1), min(v2, v3)) - vec2(blurWidth);
        vec2 boundsMax = max(max(v0, v1), max(v2, v3)) + vec2(blurWidth);

        if (any(lessThan(vu, boundsMin)) || any(greaterThan(vu, boundsMax))) {
            return;
        }

        sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);
    }

    float trailAlpha = antialising(sdfTrail, blurWidth);
    if (trailAlpha <= 0.0) {
        return;
    }

    vec4 trail = getTrailColor();
    float finalAlpha = trail.a * trailAlpha;
    vec4 newColor = mix(fragColor, vec4(trail.rgb, fragColor.a), finalAlpha);
    vec2 cursorDistance = abs(vu - centerCC);
    float cursorMask = step(cursorDistance.x, currentCursor.z * 0.5)
                     * step(cursorDistance.y, currentCursor.w * 0.5);
    fragColor = mix(newColor, fragColor, cursorMask);
}
