#ifdef INSTANCED
	attribute vec3 offset;
	attribute vec3 iColor;
	attribute float iScale;
	attribute vec4 orientation;
#endif
#include <common>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

vec3 applyQuaternionToVector( vec4 q, vec3 v ){
	return v + 2.0 * cross( q.xyz, cross( q.xyz, v ) + q.w * v );
}

void main() {
    #include <uv_vertex>
    #include <skinbase_vertex>
    #ifdef USE_DISPLACEMENTMAP
        #include <beginnormal_vertex>
        #include <morphnormal_vertex>
        #include <skinnormal_vertex>
    #endif
    #include <begin_vertex>
    // instanced
    #ifdef INSTANCED
		transformed *= iScale;
		vec3 vPosition = applyQuaternionToVector(orientation, transformed);
	#endif
    #include <morphtarget_vertex>
    #include <skinning_vertex>
    #include <displacementmap_vertex>
    #ifndef INSTANCED
		#include <project_vertex>
	#endif
	#ifdef INSTANCED
		vec4 mvPosition = modelViewMatrix * vec4( offset + vPosition, 1.0 );

		gl_Position = projectionMatrix * mvPosition;
	#endif
    #include <logdepthbuf_vertex>
    #include <clipping_planes_vertex>
}