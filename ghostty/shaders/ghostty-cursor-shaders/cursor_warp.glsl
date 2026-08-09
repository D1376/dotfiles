// sRGB -> Linear conversion (needed because Ghostty passes sRGB values but the shader pipeline operates in linear color space)
vec3 sRGBToLinear(vec3 c) {
    return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(vec3(0.04045), c));
}

// --- CONFIGURATION ---
vec4 getTrailColor() {
    return vec4(sRGBToLinear(iCurrentCursorColor.rgb), iCurrentCursorColor.a); // for custom color: vec4(0.2, 0.6, 1.0, 0.5); (wrap in sRGBToLinear for correct brightness)
}
const float DURATION = 0.2; // total animation time
const bool ANIMATE_WHEN_UNFOCUSED = false; // Ghostty 1.3+: allow effects while the surface is unfocused
const float TRAIL_SIZE = 0.65; // 0.0 = all corners move together. 1.0 = max smear (leading corners jump instantly)
const float THRESHOLD_MIN_DISTANCE = 1.5; // min distance to show trail (units of cursor height)
const float BLUR = 1.0; // blur size in pixels (for antialiasing)
const float TRAIL_THICKNESS = 1.0;  // 1.0 = full cursor height, 0.0 = zero height, >1.0 = funky aah
const float TRAIL_THICKNESS_X = 0.9;

const float FADE_ENABLED = 0.0; // 1.0 to enable fade gradient along the trail, 0.0 to disable
const float FADE_EXPONENT = 5.0; // exponent for fade gradient along the trail

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

// // Parametric Spring
// float ease(float x) {
//     x = clamp(x, 0.0, 1.0);
//     float decay = exp(-SPRING_DAMPING * SPRING_STIFFNESS * x);
//     float freq = sqrt(SPRING_STIFFNESS * (1.0 - SPRING_DAMPING * SPRING_DAMPING));
//     float osc = cos(freq * 6.283185 * x) + (SPRING_DAMPING * sqrt(SPRING_STIFFNESS) / freq) * sin(freq * 6.283185 * x);
//     return 1.0 - decay * osc;
// }

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

float getSdfConvexQuad(in vec2 p, in vec2 v1, in vec2 v2, in vec2 v3, in vec2 v4) {
    float s = 1.0;
    float d = dot(p - v1, p - v1);

    d = seg(p, v1, v2, s, d);
    d = seg(p, v2, v3, s, d);
    d = seg(p, v3, v4, s, d);
    d = seg(p, v4, v1, s, d);

    return s * sqrt(d);
}

float antialising(float distance, float blurWidth) {
    if (blurWidth <= 0.0) {
        return step(distance, 0.0);
    }
    return 1.0 - smoothstep(0.0, blurWidth, distance);
}

// Determines animation duration based on a corner's alignment with the move direction(dot product)
// dot_val will be in [-2, 2]
// > 0.5 (1 or 2) = Leading
// > -0.5 (0)     = Side
// <= -0.5 (-1 or -2) = Trailing
float getDurationFromDot(float dot_val, float DURATION_LEAD, float DURATION_SIDE, float DURATION_TRAIL) {
    float isLead = step(0.5, dot_val);
    float isSide = step(-0.5, dot_val) * (1.0 - isLead);
    
    // Start with trailing duration
    float duration = mix(DURATION_TRAIL, DURATION_SIDE, isSide);
    // Mix in leading duration
    duration = mix(duration, DURATION_LEAD, isLead);
    return duration;
}

float getAnimationProgress(float elapsed, float duration) {
    if (duration <= 0.0) {
        return 1.0;
    }
    return ease(clamp(elapsed / duration, 0.0, 1.0));
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
            || baseProgress >= DURATION - 0.001) {
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
    vec2 halfSizeCC = currentCursor.zw * 0.5;

    float ccHalfHeight = currentCursor.w * 0.5;
    float ccCenterY = currentCursor.y - ccHalfHeight;
    float ccNewHalfHeight = ccHalfHeight * TRAIL_THICKNESS;
    float ccNewTopY = ccCenterY + ccNewHalfHeight;
    float ccNewBottomY = ccCenterY - ccNewHalfHeight;
    float ccHalfWidth = currentCursor.z * 0.5;
    float ccCenterX = currentCursor.x + ccHalfWidth;
    float ccNewHalfWidth = ccHalfWidth * TRAIL_THICKNESS_X;
    float ccNewLeftX = ccCenterX - ccNewHalfWidth;
    float ccNewRightX = ccCenterX + ccNewHalfWidth;
    vec2 ccTopLeft = vec2(ccNewLeftX, ccNewTopY);
    vec2 ccTopRight = vec2(ccNewRightX, ccNewTopY);
    vec2 ccBottomLeft = vec2(ccNewLeftX, ccNewBottomY);
    vec2 ccBottomRight = vec2(ccNewRightX, ccNewBottomY);

    float cpHalfHeight = previousCursor.w * 0.5;
    float cpCenterY = previousCursor.y - cpHalfHeight;
    float cpNewHalfHeight = cpHalfHeight * TRAIL_THICKNESS;
    float cpNewTopY = cpCenterY + cpNewHalfHeight;
    float cpNewBottomY = cpCenterY - cpNewHalfHeight;
    float cpHalfWidth = previousCursor.z * 0.5;
    float cpCenterX = previousCursor.x + cpHalfWidth;
    float cpNewHalfWidth = cpHalfWidth * TRAIL_THICKNESS_X;
    float cpNewLeftX = cpCenterX - cpNewHalfWidth;
    float cpNewRightX = cpCenterX + cpNewHalfWidth;
    vec2 cpTopLeft = vec2(cpNewLeftX, cpNewTopY);
    vec2 cpTopRight = vec2(cpNewRightX, cpNewTopY);
    vec2 cpBottomLeft = vec2(cpNewLeftX, cpNewBottomY);
    vec2 cpBottomRight = vec2(cpNewRightX, cpNewBottomY);

    const float DURATION_TRAIL = DURATION;
    const float DURATION_LEAD = DURATION * (1.0 - TRAIL_SIZE);
    const float DURATION_SIDE = (DURATION_LEAD + DURATION_TRAIL) * 0.5;
    vec2 moveVector = centerCC - centerCP;
    vec2 moveDirection = sign(moveVector);
    float dotTopLeft = dot(vec2(-1.0, 1.0), moveDirection);
    float dotTopRight = dot(vec2(1.0, 1.0), moveDirection);
    float dotBottomLeft = dot(vec2(-1.0, -1.0), moveDirection);
    float dotBottomRight = dot(vec2(1.0, -1.0), moveDirection);
    float durationTopLeft = getDurationFromDot(dotTopLeft, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
    float durationTopRight = getDurationFromDot(dotTopRight, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
    float durationBottomLeft = getDurationFromDot(dotBottomLeft, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
    float durationBottomRight = getDurationFromDot(dotBottomRight, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
    float isMovingRight = step(0.5, moveDirection.x);
    float isMovingLeft = step(0.5, -moveDirection.x);
    float rightEdgeDot = (dotTopRight + dotBottomRight) * 0.5;
    float leftEdgeDot = (dotTopLeft + dotBottomLeft) * 0.5;
    float rightRailDuration = getDurationFromDot(rightEdgeDot, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
    float leftRailDuration = getDurationFromDot(leftEdgeDot, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
    durationTopLeft = mix(durationTopLeft, leftRailDuration, isMovingLeft);
    durationBottomLeft = mix(durationBottomLeft, leftRailDuration, isMovingLeft);
    durationTopRight = mix(durationTopRight, rightRailDuration, isMovingRight);
    durationBottomRight = mix(durationBottomRight, rightRailDuration, isMovingRight);

    float progressTopLeft = getAnimationProgress(baseProgress, durationTopLeft);
    float progressTopRight = getAnimationProgress(baseProgress, durationTopRight);
    float progressBottomLeft = getAnimationProgress(baseProgress, durationBottomLeft);
    float progressBottomRight = getAnimationProgress(baseProgress, durationBottomRight);
    vec2 vTopLeft = mix(cpTopLeft, ccTopLeft, progressTopLeft);
    vec2 vTopRight = mix(cpTopRight, ccTopRight, progressTopRight);
    vec2 vBottomRight = mix(cpBottomRight, ccBottomRight, progressBottomRight);
    vec2 vBottomLeft = mix(cpBottomLeft, ccBottomLeft, progressBottomLeft);
    float blurWidth = max(BLUR, 0.0) * coordinateScale;
    vec2 boundsMin = min(min(vTopLeft, vTopRight), min(vBottomRight, vBottomLeft)) - vec2(blurWidth);
    vec2 boundsMax = max(max(vTopLeft, vTopRight), max(vBottomRight, vBottomLeft)) + vec2(blurWidth);

    if (any(lessThan(vu, boundsMin)) || any(greaterThan(vu, boundsMax))) {
        return;
    }

    float sdfTrail = getSdfConvexQuad(vu, vTopLeft, vTopRight, vBottomRight, vBottomLeft);
    float shapeAlpha = antialising(sdfTrail, blurWidth);
    if (shapeAlpha <= 0.0) {
        return;
    }

    vec4 trail = getTrailColor();
    if (FADE_ENABLED > 0.5) {
        vec2 fragmentFromPrevious = vu - centerCP;
        float movementLengthSquared = dot(moveVector, moveVector);
        float fadeProgress = clamp(
            dot(fragmentFromPrevious, moveVector) / (movementLengthSquared + 1e-6),
            0.0,
            1.0
        );
        trail.a *= pow(fadeProgress, FADE_EXPONENT);
    }

    float finalAlpha = trail.a * shapeAlpha;
    vec4 newColor = mix(fragColor, vec4(trail.rgb, fragColor.a), finalAlpha);
    vec2 cursorDistance = abs(vu - centerCC);
    float cursorMask = step(cursorDistance.x, halfSizeCC.x)
                     * step(cursorDistance.y, halfSizeCC.y);
    fragColor = mix(newColor, fragColor, cursorMask);
}
