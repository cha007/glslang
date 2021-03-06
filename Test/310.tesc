#version 310 es

#extension GL_OES_tessellation_shader : enable

layout(vertices = 4) out;
int outa[gl_out.length()];

layout(quads) in;                   // ERROR
layout(ccw) out;                    // ERROR
layout(fractional_even_spacing) in; // ERROR

patch in vec4 patchIn;              // ERROR
patch out vec4 patchOut;

void main()
{
    barrier();

    int a = gl_MaxTessControlInputComponents +
            gl_MaxTessControlOutputComponents +
            gl_MaxTessControlTextureImageUnits +
            gl_MaxTessControlUniformComponents +
            gl_MaxTessControlTotalOutputComponents;

    vec4 p = gl_in[1].gl_Position;
    float ps = gl_in[1].gl_PointSize;        // ERROR, need point_size extension
    float cd = gl_in[1].gl_ClipDistance[2];  // ERROR, not in ES

    int pvi = gl_PatchVerticesIn;
    int pid = gl_PrimitiveID;
    int iid = gl_InvocationID;

    gl_out[1].gl_Position = p;
    gl_out[1].gl_PointSize = ps;        // ERROR, need point_size extension
    gl_out[1].gl_ClipDistance[1] = cd;  // ERROR, not in ES

    gl_TessLevelOuter[3] = 3.2;
    gl_TessLevelInner[1] = 1.3;

    if (a > 10)
        barrier();           // ERROR
    else
        barrier();           // ERROR

    barrier();

    do {
        barrier();           // ERROR
    } while (a > 10);

    switch (a) {
    default:
        barrier();           // ERROR
        break;
    }
    a < 12 ? a : (barrier(), a); // ERROR
    {
        barrier();
    }

    return;

    barrier();               // ERROR
}

layout(vertices = 4) in;    // ERROR, not on in
layout(vertices = 5) out;   // ERROR, changing #

void foo()
{
    gl_out[4].gl_Position;  // ERROR, out of range

    barrier();              // ERROR, not in main
}

in vec2 ina;                // ERROR, not array
in vec2 inb[];
in vec2 inc[18];            // ERROR, wrong size
in vec2 ind[gl_MaxPatchVertices];
patch out float implA[];    // ERROR, not sized

#extension GL_ARB_separate_shader_objects : enable

layout(location = 3) in vec4 ivla[];
layout(location = 4) in vec4 ivlb[];
layout(location = 4) in vec4 ivlc[];  // ERROR, overlapping

layout(location = 3) out vec4 ovla[];
layout(location = 4) out vec4 ovlb[];
layout(location = 4) out vec4 ovlc[];  // ERROR, overlapping

void foop()
{
    precise float d;                  // ERROR without gpu_shader5
    d = fma(d, d, d);                 // ERROR without gpu_shader5
}

patch out pinbn {
    int a;
} pinbi;

centroid out vec3 myColor2[];
centroid in vec3 centr[];
sample out vec4 perSampleColor[];   // ERROR without sample extensions

layout(vertices = 4) out float badlay[];   // ERROR, not on a variable
out float misSized[5];              // ERROR, size doesn't match
out float okaySize[4];

#extension GL_OES_tessellation_point_size : enable

void pointSize2()
{
    float ps = gl_in[1].gl_PointSize;
    gl_out[1].gl_PointSize = ps;
}

// for testing with gpu_shader5
//precise vec3 pv3;
//
//void foop()
//{
//    precise double d;
//
//    pv3 *= pv3;
//    pv3 = fma(pv3, pv3, pv3);
//    d = fma(d, d, d);
//}
//
