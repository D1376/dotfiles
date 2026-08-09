// sRGB -> Linear conversion (needed because Ghostty passes sRGB values but the shader pipeline operates in linear color space)
vec3 sRGBToLinear(vec3 c) {
    return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(vec3(0.04045), c));
}

// --- CONFIGURATION ---
vec4 getTrailColor() {
    return vec4(sRGBToLinear(iCurrentCursorColor.rgb), iCurrentCursorColor.a); // for custom color: vec4(0.2, 0.6, 1.0, 0.5); (wrap in sRGBToLinear for correct brightness)
}
const float DURATION = 0.2; // in seconds
const bool ANIMATE_WHEN_UNFOCUSED = false; // Ghostty 1.3+: allow effects while the surface is unfocused
const float TRAIL_LENGTH = 0.5;
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

// Smooth polynomial ease-out: finite initial speed and zero velocity at the end.
float ease(float x) {
    return x * (1.5 - 0.5 * x * x);
}

// // EaseOutCubic
// float ease(float x) {
//     float remaining = 1.0 - x;
//     return 1.0 - remaining * remaining * remaining;
// }

// // EaseOutQuart
// float ease(float x) {
//     return 1.0 - pow(1.0 - x, 4.0);
// }

// // EaseOutQuint
// float ease(float x) {
//     return 1.0 - pow(1.0 - x, 5.0);
// }

// EaseOutSine
// float ease(float x) {
//     return sin((x * PI) / 2.0);
// }

// // EaseOutExpo
// float ease(float x) {
//     return x == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * x);
// }

// // EaseOutCirc
// float ease(float x) {
//     return sqrt(1.0 - pow(x - 1.0, 2.0));
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

float getSdfRectangle(in vec2 point, in vec2 center, in vec2 halfSize)
{
    vec2 d = abs(point - center) - halfSize;
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

float getTopVertexFlag(vec2 a, vec2 b) {
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
    float minDistancePixels = iCurrentCursor.w * 1.5;

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

    float progress = clamp(baseProgress / DURATION, 0.0, 1.0);
    float shrinkFactor = ease(progress);
    float blurWidth = max(BLUR, 0.0) * coordinateScale;
    vec2 delta = abs(centerCC - centerCP);
    const float STRAIGHT_MOVE_THRESHOLD = 0.001;
    bool isStraightMove = delta.x <= STRAIGHT_MOVE_THRESHOLD
                       || delta.y <= STRAIGHT_MOVE_THRESHOLD;
    float sdfTrail;

    if (isStraightMove) {
        vec2 minCenter = min(centerCP, centerCC);
        vec2 maxCenter = max(centerCP, centerCC);
        vec2 fullSize = (maxCenter - minCenter) + currentCursor.zw;
        vec2 fullCenter = (minCenter + maxCenter) * 0.5;
        vec2 startSize = mix(currentCursor.zw, fullSize, TRAIL_LENGTH);
        vec2 startCenter = mix(centerCC, fullCenter, TRAIL_LENGTH);
        vec2 animatedSize = mix(startSize, currentCursor.zw, shrinkFactor);
        vec2 animatedCenter = mix(startCenter, centerCC, shrinkFactor);
        vec2 halfSize = animatedSize * 0.5;
        vec2 boundsPadding = vec2(blurWidth);

        if (any(lessThan(vu, animatedCenter - halfSize - boundsPadding))
                || any(greaterThan(vu, animatedCenter + halfSize + boundsPadding))) {
            return;
        }

        sdfTrail = getSdfRectangle(vu, animatedCenter, halfSize);
    } else {
        float topVertexFlag = getTopVertexFlag(currentCursor.xy, previousCursor.xy);
        float bottomVertexFlag = 1.0 - topVertexFlag;
        vec2 v0 = vec2(currentCursor.x + currentCursor.z * topVertexFlag, currentCursor.y - currentCursor.w);
        vec2 v1 = vec2(currentCursor.x + currentCursor.z * bottomVertexFlag, currentCursor.y);
        vec2 v2Full = vec2(previousCursor.x + currentCursor.z * bottomVertexFlag, previousCursor.y);
        vec2 v3Full = vec2(previousCursor.x + currentCursor.z * topVertexFlag, previousCursor.y - previousCursor.w);
        vec2 v2Start = mix(v1, v2Full, TRAIL_LENGTH);
        vec2 v3Start = mix(v0, v3Full, TRAIL_LENGTH);
        vec2 v2 = mix(v2Start, v1, shrinkFactor);
        vec2 v3 = mix(v3Start, v0, shrinkFactor);
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
