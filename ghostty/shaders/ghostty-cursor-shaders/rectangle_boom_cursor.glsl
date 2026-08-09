// CONFIGURATION
const float DURATION = 0.18;               // How long the ripple animates (seconds)
const bool ANIMATE_WHEN_UNFOCUSED = false; // Ghostty 1.3+: allow effects while the surface is unfocused
const float FADE_IN_FRACTION = 0.15;       // 0.0 disables; 0.10-0.25 is the useful range
const float MAX_SIZE = 0.05;             // Max radius in normalized coords (0.5 = 1/4 screen height)
const float ANIMATION_START_OFFSET = 0.0;        // Start the ripple slightly progressed [0.0, 1.0)
vec4 COLOR = vec4(0.35, 0.36, 0.44, 1.0); // change to iCurrentCursorColor for your cursor's color
const float CURSOR_WIDTH_CHANGE_THRESHOLD = 0.5; // Triggers ripple if either cursor dimension changes by this fraction
const float BLUR = 3.0;                    // Blur level in pixels

// Easing functions
float easeOutQuad(float t) {
    return 1.0 - (1.0 - t) * (1.0 - t);
}
float easeInOutQuad(float t) {
    return t < 0.5 ? 2.0 * t * t : 1.0 - pow(-2.0 * t + 2.0, 2.0) / 2.0;
}
float easeOutCubic(float t) {
    return 1.0 - pow(1.0 - t, 3.0);
}
float easeOutQuart(float t) {
    return 1.0 - pow(1.0 - t, 4.0);
}
float easeOutQuint(float t) {
    return 1.0 - pow(1.0 - t, 5.0);
}
float easeOutExpo(float t) {
    return t == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * t);
}
float easeOutCirc(float t) {
    float remaining = 1.0 - t;
    return sqrt(1.0 - remaining * remaining);
}
float easeOutSine(float t) {
    return sin((t * 3.1415916) / 2.0);
}
float easeOutElastic(float t) {
    const float c4 = (2.0 * 3.1415916) / 3.0;
    return t == 0.0 ? 0.0 : t == 1.0 ? 1.0 : pow(2.0, -10.0 * t) * sin((t * 10.0 - 0.75) * c4) + 1.0;
}
float easeOutBounce(float t) {
    const float n1 = 7.5625;
    const float d1 = 2.75;
    if (t < 1.0 / d1) {
        return n1 * t * t;
    } else if (t < 2.0 / d1) {
        return n1 * (t -= 1.5 / d1) * t + 0.75;
    } else if (t < 2.5 / d1) {
        return n1 * (t -= 2.25 / d1) * t + 0.9375;
    } else {
        return n1 * (t -= 2.625 / d1) * t + 0.984375;
    }
}
float easeOutBack(float t) {
    const float c1 = 1.70158;
    const float c3 = c1 + 1.0;
    return 1.0 + c3 * pow(t - 1.0, 3.0) + c1 * pow(t - 1.0, 2.0);
}

// Pulse fade functions
float smoothstepPulse(float t) {
    return 4.0 * t * (1.0 - t);
}
float easeOutPulse(float t) {
    return t * (2.0 - t);
}
float powerCurvePulse(float t) {
    float x = t * 2.0 - 1.0;
    return 1.0 - x * x;
}
float doubleSmoothstepPulse(float t) {
    return smoothstep(0.0, 0.5, t) * (1.0 - smoothstep(0.5, 1.0, t));
}
float exponentialDecayPulse(float t) {
    return exp(-3.0 * t) * sin(t * 3.1415916);
}
float sinPulse(float t) {
    return sin(t * 3.1415916);
}

float getEffectCoverage(float signedDistance, float blurWidth) {
    if (blurWidth <= 0.0) {
        return step(signedDistance, 0.0);
    }
    return 1.0 - smoothstep(-blurWidth, blurWidth, signedDistance);
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

    if (DURATION <= 0.0) {
        return;
    }

    float baseProgress = (iTime - iTimeCursorChange) / DURATION;
    float rippleProgress = baseProgress + ANIMATION_START_OFFSET;
    if (!(rippleProgress >= 0.0 && rippleProgress < 1.0)) {
        return;
    }
    if (any(lessThanEqual(iCurrentCursor.zw, vec2(0.0)))
            || any(lessThanEqual(iPreviousCursor.zw, vec2(0.0)))) {
        return;
    }
    vec2 cellSize = max(iCurrentCursor.zw, iPreviousCursor.zw);
    vec2 sizeChange = abs(iCurrentCursor.zw - iPreviousCursor.zw);
    bool isModeChange = CURSOR_WIDTH_CHANGE_THRESHOLD <= 0.0
        ? any(greaterThan(sizeChange, vec2(0.0)))
        : any(greaterThanEqual(sizeChange, cellSize * CURSOR_WIDTH_CHANGE_THRESHOLD));

    // This condition is uniform, so inactive frames only sample the terminal texture.
    if (!isModeChange) {
        return;
    }

    // Finite-velocity cubic expansion plus a short smooth attack softens the first-frame flash.
    float remaining = 1.0 - rippleProgress;
    float remainingSquared = remaining * remaining;
    float easedProgress = 1.0 - remainingSquared * remaining;
    // Alternative expansion: easeOutQuad(rippleProgress), easeOutBack(rippleProgress), etc.
    float fadeInProgress = min(baseProgress, rippleProgress);
    float fadeIn = FADE_IN_FRACTION <= 0.0
        ? 1.0
        : smoothstep(0.0, FADE_IN_FRACTION, fadeInProgress);
    float fade = fadeIn * remainingSquared;
    // Alternative fade: 1.0, 1.0 - easedProgress, or 1.0 - smoothstepPulse(rippleProgress).

    // Work in pixels. This is algebraically equivalent to the former normalized coordinates.
    float rippleExpansion = easedProgress * MAX_SIZE * iResolution.y * 0.5;
    float blurWidth = max(BLUR, 0.0);
    vec2 halfSize = iCurrentCursor.zw * 0.5 + vec2(rippleExpansion);
    vec2 cursorCenter = iCurrentCursor.xy + iCurrentCursor.zw * vec2(0.5, -0.5);
    vec2 distanceToEdge = abs(fragCoord - cursorCenter) - halfSize;

    // Outside the expanded AABB, smoothstep is exactly zero.
    if (max(distanceToEdge.x, distanceToEdge.y) > blurWidth) {
        return;
    }

    float sdfRectangle = length(max(distanceToEdge, 0.0))
                       + min(max(distanceToEdge.x, distanceToEdge.y), 0.0);
    float ripple = getEffectCoverage(sdfRectangle, blurWidth) * fade;
    fragColor = mix(fragColor, vec4(COLOR.rgb, fragColor.a), ripple * COLOR.a);
}
