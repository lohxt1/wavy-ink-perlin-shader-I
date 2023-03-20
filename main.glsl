// https://twigl.app/?ol=true&ss=-NQzQXR99fUaSYlVRJLt

precision mediump float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

const float PI = 3.14159265359;

float rand(vec2 co) {
  return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);
  vec2 u = f * f * (3.0 - 2.0 * f) * 1.0;
  return mix(
    mix(rand(i + vec2(0.0, 0.0)), rand(i + vec2(1.0, 0.0)), u.x),
    mix(rand(i + vec2(0.0, 1.0)), rand(i + vec2(1.0, 1.0)), u.x),
    u.y
  );
}

vec3 wave(float x, float z, float t) {
  float k = 2.0 * PI / 10.0; // wave number
  float w = sqrt(9.81 * k); // wave speed
  float phi = k * (dot(vec2(x, z), vec2(1.0, 0.0)) - w * t); // phase
  float A = 0.2; // amplitude
  float Q = 0.1; // steepness
  vec2 d = vec2(cos(phi), sin(phi)); // direction
  float dk = Q / k; // wavelength
  vec2 p = vec2(x, z) - dk * A * d; // position
  return vec3(A * d.y * cos(dk * dot(d, p)), A * sin(dk * dot(d, p)), A * d.x * cos(dk * dot(d, p)));
}

void main() {
  vec2 uv = gl_FragCoord.xy / resolution.xy;
  uv = uv * 2.0 - 1.0;
  uv.x *= resolution.x / resolution.y;
  
  vec3 pos = vec3(uv, 0.0);
  pos += wave(pos.x*2.0, pos.z*10.0, 3.0*time);
  pos += wave(pos.x*2.0, pos.z*10.0, time * 2.7);
  pos += wave(pos.x*2.0, pos.z*1.0, time * 0.3);
  
  float depth = 1.0 + pos.y;
  vec3 color = mix(vec3(0.0, 0.0, 0.0), vec3(0.0, 1.0, 1.0), pow(depth, 10.0));
  
  float noiseScale = 25.0;
  float noiseAmplitude = 5.0;
  float noiseOffset = time * 6.5;
  float n = noise(pos.xy * noiseScale + vec2(noiseOffset));
  pos += vec3(n * noiseAmplitude, 0.0, n * noiseAmplitude);
  
  color = mix(color, vec3(0.0, 0.2, 0.2), n * 0.9);
  gl_FragColor = vec4(color, 1.0);
}
